const { onRequest } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Logger for debugging
const logger = require("firebase-functions/logger");

// Function to send notifications to all users or a specific topic
async function sendNotification(title, body, topicName = null) {
  try {
    // Ensure title and body are not empty
    if (!title || !body) {
      logger.warn(
        "Notification title or body is empty. Notification not sent."
      );
      return; // Exit the function early
    }

    if (topicName) {
      // If a topic name is provided, send to all users subscribed to this topic
      const message = {
        notification: { title, body },
        topic: topicName
      };
      await admin.messaging().send(message);
      logger.info(`Notification sent to topic ${topicName}`);
    } else {
      // Send to individual users by their tokens
      const tokens = [];
      const usersSnapshot = await admin.firestore().collection("users").get();
      usersSnapshot.forEach((doc) => {
        const userData = doc.data();
        if (userData.token) {
          tokens.push(userData.token);
        }
      });

      if (tokens.length > 0) {
        const message = {
          notification: { title, body },
          tokens: tokens // List of device tokens
        };

        const response = await admin.messaging().sendMulticast(message);
        logger.info(
          `Notifications sent successfully: ${response.successCount} sent, ${response.failureCount} failed.`
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
    const startOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 1)); // Monday as start
    const endOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 7)); // Sunday as end

    logger.info(`Start of Week: ${startOfWeek}`);
    logger.info(`End of Week: ${endOfWeek}`);

    const usersSnapshot = await admin.firestore().collection("users").get();

    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      const userDocRef = admin.firestore().collection("users").doc(userId);

      // Get all the calculated values for the week
      const calculatedValuesSnapshot = await userDocRef
        .collection("calculatedValues")
        .where("timestamp", ">=", startOfWeek)
        .where("timestamp", "<=", endOfWeek)
        .get();

      if (!calculatedValuesSnapshot.empty) {
        let combinedData = {
          calculatedValues: [],
          mileageFee: [],
          truckPayment: [],
          transferTimestamp: new Date().toISOString()
        };

        // Collect all calculated values documents
        for (const doc of calculatedValuesSnapshot.docs) {
          combinedData.calculatedValues.push(doc.data());
          try {
            // Delete the document after transferring
            await doc.ref.delete();
            logger.info(
              `Calculated Values Document ${doc.id} deleted successfully.`
            );
          } catch (e) {
            logger.error(`Error deleting document ${doc.id}: ${e}`);
          }
        }

        // Collect all mileage fees for the user
        const mileageFeeSnapshot = await userDocRef
          .collection("perMileageCost")
          .get();
        for (const mileageDoc of mileageFeeSnapshot.docs) {
          combinedData.mileageFee.push(mileageDoc.data());
        }

        // Collect all truck payments for the user
        const truckPaymentSnapshot = await userDocRef
          .collection("truckPaymentCollection")
          .get();
        for (const truckDoc of truckPaymentSnapshot.docs) {
          combinedData.truckPayment.push(truckDoc.data());
        }

        // Save the combined data to the 'history' collection
        const historyDocId = admin.firestore().collection("users").doc().id;
        const newHistoryDoc = userDocRef
          .collection("history")
          .doc(historyDocId);
        await newHistoryDoc.set(combinedData);

        logger.info(
          `Data transferred and deleted successfully for user ${userId}.`
        );
      } else {
        logger.info(
          `No calculated values found for user ${userId} in the current week.`
        );
      }
    }
  } catch (e) {
    logger.error("Error in transferAndDeleteWeeklyData:", e);
  }
}

// Scheduled function to send Monday morning notification to all users and transfer data
exports.sendMondayNotification = onSchedule(
  {
    schedule: "every monday 06:00",
    timeZone: "America/Chicago",
    options: {
      cpu: 1,
      memory: "512MiB"
    }
  },
  async (context) => {
    // Send notification and transfer data
    await sendNotification(
      "Your new week starts!",
      "It's Monday morning. Get ready to add your loads.",
      "loads"
    );
    await transferAndDeleteWeeklyData();
  }
);

// Scheduled function to send reminder notifications on Friday
exports.remindToAddLoadFriday = onSchedule(
  {
    schedule: "every friday 06:00",
    timeZone: "America/Chicago",
    options: {
      cpu: 1,
      memory: "512MiB"
    }
  },
  async (context) => {
    // Send reminder notification
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
    options: {
      cpu: 1,
      memory: "512MiB"
    }
  },
  async (context) => {
    // Send hurry up notification
    await sendNotification(
      "Hurry up to add loads!",
      "Hurry up! Your loads will be transferred soon.",
      "loads"
    );
  }
);

// Example HTTP function (for testing purposes)
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", { structuredData: true });
  response.send("Hello from Firebase!");
});
