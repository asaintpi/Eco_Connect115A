const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Function to fetch posts
exports.getPosts = functions.https.onRequest(async (req, res) => {
  try {
    const postsSnapshot = await admin.firestore().collection("posts").get();
    const posts = postsSnapshot.docs.map((doc) => doc.data());
    res.status(200).json(posts);
  } catch (error) {
    res.status(500).send(error.toString());
  }
});
