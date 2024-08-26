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

// Function to transfer and delete weekly data
async function transferAndDeleteWeeklyData() {
    try {
        // Calculate the start and end dates of the current week
        const now = new Date();
        const startOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 1)); // Monday as start
        const endOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 7)); // Sunday as end

        logger.info(`Start of Week: ${startOfWeek}`);
        logger.info(`End of Week: ${endOfWeek}`);

        // Query documents in the calculatedValues subcollection within the current week
        const usersSnapshot = await admin.firestore().collection('users').get();

        for (const userDoc of usersSnapshot.docs) {
            const userId = userDoc.id;
            const userDocRef = admin.firestore().collection('users').doc(userId);

            // Fetch the single document for the current week
            const calculatedValuesSnapshot = await userDocRef.collection('calculatedValues')
                .where('timestamp', '>=', startOfWeek)
                .where('timestamp', '<=', endOfWeek)
                .limit(1) // There should be only one document
                .get();

            if (!calculatedValuesSnapshot.empty) {
                const doc = calculatedValuesSnapshot.docs[0];

                // Prepare data to be transferred
                const combinedData = {
                    calculatedValues: doc.data(),
                    mileageFee: [],
                    truckPayment: [],
                    transferTimestamp: new Date().toISOString() // Add a timestamp for when the transfer happens
                };

                // Fetch related data without deleting it
                const mileageFeeSnapshot = await userDocRef.collection('perMileageCost').get();
                const truckPaymentSnapshot = await userDocRef.collection('truckPaymentCollection').get();

                // Add mileage fee data
                for (const mileageDoc of mileageFeeSnapshot.docs) {
                    combinedData.mileageFee.push(mileageDoc.data());
                }

                // Add truck payment data
                for (const truckDoc of truckPaymentSnapshot.docs) {
                    combinedData.truckPayment.push(truckDoc.data());
                }

                // Set a new document in the history collection with a unique ID
                const historyDocId = admin.firestore().collection('users').doc().id; // Generate a unique ID
                const newHistoryDoc = userDocRef.collection('history').doc(historyDocId);
                await newHistoryDoc.set(combinedData);

                // Delete the transferred document
                try {
                    await doc.ref.delete();
                    logger.info(`Document ${doc.id} deleted successfully.`);
                } catch (e) {
                    logger.error(`Error deleting document ${doc.id}: ${e}`);
                }

                logger.info(`Data transferred and deleted successfully for user ${userId}.`);
            } else {
                logger.info(`No documents found for user ${userId} in the current week.`);
            }
        }
    } catch (e) {
        logger.error('Error in transferAndDeleteWeeklyData:', e);
    }
}


// Scheduled function to send Monday morning notification to all users and transfer data
exports.sendMondayNotification = onSchedule({
    schedule: 'every monday 06:00',
    timeZone: 'America/Chicago',
    options: {
        cpu: 1, // 1 CPU core
        memory: '512MiB', // 512 MiB of memory
    }
}, async (context) => {
    await sendNotification("Your new week starts!", "It's Monday morning. Get ready to add your loads.", 'loads');
    await transferAndDeleteWeeklyData(); // Use the weekly transfer function
});

// Scheduled function to send reminder notifications on Friday and transfer data
exports.remindToAddLoadFriday = onSchedule({
    schedule: 'every friday 06:00',
    timeZone: 'America/Chicago',
    options: {
        cpu: 1, // 1 CPU core
        memory: '512MiB', // 512 MiB of memory
    }
}, async (context) => {
    await sendNotification("Reminder: Add Your Load", "Please make sure to add your loads today.", 'loads');
});

// Scheduled function to send "Hurry up to add loads" notification on Sunday, and transfer data
exports.sendSundayNotification = onSchedule({
    schedule: 'every sunday 06:00',
    timeZone: 'America/Chicago',
    options: {
        cpu: 1, // 1 CPU core
        memory: '512MiB', // 512 MiB of memory
    }
}, async (context) => {
    await sendNotification("Hurry up to add loads!", "Hurry up! Your loads will be transferred soon.", 'loads');
});

// Example HTTP function (can be used for testing)
exports.helloWorld = onRequest((request, response) => {
    logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
});
