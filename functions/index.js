const { onRequest } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Logger for debugging
const logger = require("firebase-functions/logger");

// Function to calculate the current week number (like 2024-W38)
function getWeekNumber(d) {
  const date = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
  date.setUTCDate(date.getUTCDate() + 4 - (date.getUTCDay() || 7));
  const yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil(((date - yearStart) / 86400000 + 1) / 7);
  return `${date.getUTCFullYear()}-W${weekNo}`;
}

// Function to send notifications to all users or a specific topic
async function sendNotification(title, body, topicName = null) {
  try {
    if (!title || !body) {
      logger.warn(
        "Notification title or body is empty. Notification not sent."
      );
      return; // Exit the function early
    }
    if (topicName) {
      const message = { notification: { title, body }, topic: topicName };
      await admin.messaging().send(message);
      logger.info(`Notification sent to topic ${topicName}`);
    } else {
      const tokens = [];
      const usersSnapshot = await admin.firestore().collection("users").get();
      usersSnapshot.forEach((doc) => {
        const userData = doc.data();
        if (userData.token) tokens.push(userData.token);
      });

      if (tokens.length > 0) {
        const message = { notification: { title, body }, tokens: tokens };
        const response = await admin.messaging().sendMulticast(message);
        logger.info(
          `Notifications sent: ${response.successCount} success, ${response.failureCount} failed.`
        );
      } else {
        logger.info("No tokens found");
      }
    }
  } catch (error) {
    logger.error("Error sending notifications", error);
  }
}

// Function to transfer and delete weekly data
async function transferAndDeleteWeeklyData() {
  try {
    const now = new Date();
    const startOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 1));
    startOfWeek.setHours(0, 0, 0, 0); // Start of Monday
    const endOfWeek = new Date(startOfWeek);
    endOfWeek.setDate(startOfWeek.getDate() + 6); // End of Sunday
    endOfWeek.setHours(23, 59, 59, 999); // End of day

    const currentWeekId = getWeekNumber(now); // Get the current week number as ID
    logger.info(`Processing data for week: ${currentWeekId}`);

    const usersSnapshot = await admin.firestore().collection("users").get();

    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      const userDocRef = admin.firestore().collection("users").doc(userId);

      // Check if the history document for this week already exists
      const historyDocRef = userDocRef.collection("history").doc(currentWeekId);
      const historyDocSnapshot = await historyDocRef.get();

      if (!historyDocSnapshot.exists) {
        logger.info(
          `No history found for user ${userId} for week ${currentWeekId}. Proceeding with transfer.`
        );

        let combinedData = {
          calculatedValues: [],
          mileageFee: [],
          truckPayment: [],
          transferTimestamp: new Date().toISOString()
        };

        // Get all calculated values for the week
        const calculatedValuesSnapshot = await userDocRef
          .collection("calculatedValues")
          .where("timestamp", ">=", startOfWeek)
          .where("timestamp", "<=", endOfWeek)
          .get();

        if (!calculatedValuesSnapshot.empty) {
          for (const doc of calculatedValuesSnapshot.docs) {
            combinedData.calculatedValues.push(doc.data());
            try {
              await doc.ref.delete(); // Delete the document after transferring
              logger.info(
                `Calculated Values Document ${doc.id} deleted for user ${userId}.`
              );
            } catch (e) {
              logger.error(`Error deleting document ${doc.id}: ${e}`);
            }
          }

          // Get all mileage fees for the user
          const mileageFeeSnapshot = await userDocRef
            .collection("perMileageCost")
            .get();
          for (const mileageDoc of mileageFeeSnapshot.docs) {
            combinedData.mileageFee.push(mileageDoc.data());
          }

          // Get all truck payments for the user
          const truckPaymentSnapshot = await userDocRef
            .collection("truckPaymentCollection")
            .get();
          for (const truckDoc of truckPaymentSnapshot.docs) {
            combinedData.truckPayment.push(truckDoc.data());
          }

          // Save the combined data to the 'history' collection for the current week
          await historyDocRef.set(combinedData);
          logger.info(
            `Data transferred and saved to history for user ${userId} for week ${currentWeekId}.`
          );
        } else {
          logger.info(
            `No calculated values found for user ${userId} for the current week.`
          );
        }
      } else {
        logger.info(
          `History already exists for user ${userId} for week ${currentWeekId}. Skipping transfer.`
        );
      }
    }
  } catch (error) {
    logger.error("Error in transferAndDeleteWeeklyData:", error);
  }
}

// Scheduled function to send Monday morning notification to all users and transfer data
exports.sendMondayNotification = onSchedule(
  {
    schedule: "every monday 06:00",
    timeZone: "America/Chicago",
    options: { cpu: 1, memory: "1GB", timeoutSeconds: 1000 } // Increase timeout to 9 minutes
  },
  async (context) => {
    await transferAndDeleteWeeklyData();
    await sendNotification(
      "Your new week starts!",
      "It's Monday morning. Get ready to add your loads.",
      "loads"
    );
  }
);

// Scheduled function to send reminder notifications on Friday
exports.remindToAddLoadFriday = onSchedule(
  {
    schedule: "every friday 06:00",
    timeZone: "America/Chicago",
    options: { cpu: 1, memory: "512MiB" }
  },
  async (context) => {
    await sendNotification(
      "Reminder: Add Your Load",
      "Please make sure to add your loads today.",
      "loads"
    );
  }
);

// Scheduled function to send "Hurry up to add loads" notification on Sunday
exports.sendSundayNotification = onSchedule(
  {
    schedule: "every sunday 06:00",
    timeZone: "America/Chicago",
    options: { cpu: 1, memory: "512MiB" }
  },
  async (context) => {
    await sendNotification(
      "Hurry up to add loads!",
      "Hurry up! Your loads will be transferred soon.",
      "loads"
    );
  }
);

// Example HTTP function to manually trigger the data transfer (for testing purposes)
exports.manualTransfer = onRequest(async (request, response) => {
  try {
    await transferAndDeleteWeeklyData();
    response.send("Manual transfer and delete operation completed.");
  } catch (error) {
    logger.error("Error during manual transfer", error);
    response.status(500).send("Error during manual transfer.");
  }
});
