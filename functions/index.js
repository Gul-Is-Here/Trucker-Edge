const { onCall } = require("firebase-functions/v2/https");
const { onSchedule } = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

// Initialize Firebase Admin SDK
admin.initializeApp();

// Logger for debugging
const logger = require("firebase-functions/logger");

// Function to send notifications to all users or a specific topic
async function sendNotification(title, body, topicName = 'loads') {
    try {
        let tokens = [];

        if (topicName) {
            // If a topic name is provided, send to all users subscribed to this topic
            const message = {
                notification: { title: title, body: body },
                topic: topicName
            };
            await admin.messaging().send(message);
            logger.info(`Notification sent to topic ${topicName}`);
        } else {
            // Send to individual users by their tokens
            const usersSnapshot = await admin.firestore().collection('users').get();
            usersSnapshot.forEach(doc => {
                const userData = doc.data();
                if (userData.token) {
                    tokens.push(userData.token);
                }
            });

            if (tokens.length > 0) {
                const message = {
                    notification: { title: title, body: body },
                    tokens: tokens // List of device tokens
                };

                const response = await admin.messaging().sendMulticast(message);
                logger.info(`Notifications sent successfully: ${response.successCount} sent, ${response.failureCount} failed.`);
            } else {
                logger.info('No tokens found');
            }
        }
    } catch (error) {
        logger.error("Error sending notifications", error);
    }
}

// Function to send Monday morning notification to all users
exports.sendMondayNotification = onSchedule('every monday 05:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Your week starts!", "It's Monday morning. Get ready to add your loads.");
});

// Function to send Friday notification to a specific topic
exports.sendFridayNotification = onSchedule('every friday 05:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Load Transfer Alert!", "Hurry up! Your loads will be transferred soon.", 'loads');
});

// Function to send load transfer notification to all users on Monday morning
exports.sendLoadTransferNotification = onSchedule('every monday 05:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Load Transferred", "Your load has been transferred.");
});

// // Example callable function (can be used for testing)
// exports.helloWorld = response(async (data, context) => {
//     logger.info("Hello logs!", { structuredData: true });
//     return { message: "Hello from Firebase!" };
// });
