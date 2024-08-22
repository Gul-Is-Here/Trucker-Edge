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
            const tokens = [];
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

// Function to transfer and delete data for all users
async function transferAndDeleteDataForAllUsers() {
    try {
        const sourceCollection = admin.firestore().collection("calculatedValues");
        const destinationCollection = admin.firestore().collection("history");

        // Fetch users
        const usersSnapshot = await admin.firestore().collection("users").get();
        
        for (const userDoc of usersSnapshot.docs) {
            const userId = userDoc.id;

            // Fetch data related to this user
            const userSourceCollection = sourceCollection.where('userId', '==', userId);
            const snapshot = await userSourceCollection.get();
            const batch = admin.firestore().batch();

            snapshot.forEach((doc) => {
                // Add the document to the destination collection
                batch.set(destinationCollection.doc(doc.id), doc.data());
            });

            // Commit the batch
            await batch.commit();
            logger.info(`Data transferred successfully for user ${userId}.`);

            // Delete documents from the source collection
            const deleteBatch = admin.firestore().batch();
            snapshot.forEach((doc) => {
                deleteBatch.delete(doc.ref);
            });

            // Commit the delete batch
            await deleteBatch.commit();
            logger.info(`Old data deleted successfully for user ${userId}.`);

            // Send notification to the user about successful data transfer
            await sendNotification("Data Transferred Successfully", "Your data has been transferred and deleted successfully.", 'loads');
        }
    } catch (error) {
        logger.error("Error transferring and deleting data", error);
    }
}

// Scheduled function to send Monday morning notification to all users and transfer data
exports.sendMondayNotification = onSchedule('every monday 06:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Your new week starts!", "It's Monday morning. Get ready to add your loads.", 'loads');
    await transferAndDeleteDataForAllUsers();
});

// Scheduled function to send reminder notifications on Tuesday, Wednesday, Thursday, Friday, and Saturday, and transfer data
exports.remindToAddLoadTuesday = onSchedule('every tuesday 06:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Reminder: Add Your Load", "Please make sure to add your loads today.", 'loads');
    await transferAndDeleteDataForAllUsers();
});

exports.remindToAddLoadWednesday = onSchedule('every wednesday 06:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Reminder: Add Your Load", "Please make sure to add your loads today.", 'loads');
    await transferAndDeleteDataForAllUsers();
});

exports.remindToAddLoadThursday = onSchedule('every thursday 06:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Reminder: Add Your Load", "Please make sure to add your loads today.", 'loads');
    await transferAndDeleteDataForAllUsers();
});

exports.remindToAddLoadFriday = onSchedule('every friday 06:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Reminder: Add Your Load", "Please make sure to add your loads today.", 'loads');
    await transferAndDeleteDataForAllUsers();
});

exports.remindToAddLoadSaturday = onSchedule('every saturday 06:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Reminder: Add Your Load", "Please make sure to add your loads today.", 'loads');
    await transferAndDeleteDataForAllUsers();
});

// Scheduled function to send "Hurry up to add loads" notification on Sunday, and transfer data
exports.sendSundayNotification = onSchedule('every sunday 06:00', {
    timeZone: 'America/Chicago'
}, async () => {
    await sendNotification("Hurry up to add loads!", "Hurry up! Your loads will be transferred soon.", 'loads');
    await transferAndDeleteDataForAllUsers();
});

// Example HTTP function (can be used for testing)
exports.helloWorld = onRequest((request, response) => {
    logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
});
