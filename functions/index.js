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

// Scheduled function to send Monday morning notification to all users and transfer data
exports.sendMondayNotification = onSchedule(
  {
    schedule: "every monday 06:00",
    timeZone: "America/Chicago",
    options: { cpu: 1, memory: "1GB", timeoutSeconds: 100000 } // Increase timeout to 9 minutes
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
