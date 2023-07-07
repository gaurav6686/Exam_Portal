const express = require('express')
const mongoose = require('mongoose')
const bodyparser = require('body-parser')
const cloudinary = require('cloudinary').v2;
const fileUpload = require('express-fileupload')
const user = require("./auth/signin");
const User = require("./model/user");

const app = express()
app.use(express.json())

mongoose.connect("mongodb+srv://Gauravd:gauravd@cluster0.hbhwc24.mongodb.net/", {
  useNewurlParser: true,
  useUnifiedtopology: true
}).then(() => {
  console.log("Connected With MongoDB");
}).catch((err) => {
  console.log(`error is ${err}`);
})


const documentSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
  },
  pdf: {
    type: String,
    required: true
  },
  name: {
    type: String,
    required: true
  },
  mobileNo: {
    type: String,
    required: true
  },
  branch: {
    type: String,
    required: true
  },
  classValue: {
    type: String,
    required: true
  },
  division: {
    type: String,
    required: true
  },
  photo: {
    type: String,
    required: true
  },
  status: {
    type: String,
    default: "Pending"
  }
});

const Document = mongoose.model('studentdatas', documentSchema);
module.exports = Document;



app.use(express.json());

cloudinary.config({
  cloud_name: 'ds197oik9',
  api_key: '592329952254324',
  api_secret: 'R_qJLiZmZzCoC3m4j3X66UJbZyo',
});

app.use(fileUpload({
  useTempFiles: true,
  limits: { fileSize: 100 * 1024 * 1024 }
}));


app.post('/api/action', async (req, res) => {
  console.log(req.body);
  try {
    const pdfFile = req.files.pdf;
    const photoFile = req.files.photo;


    const pdfResult = await cloudinary.uploader.upload(pdfFile.tempFilePath);
    console.log(pdfResult);

    const photoResult = await cloudinary.uploader.upload(photoFile.tempFilePath);
    console.log(photoResult);

    const document = new Document({
      userId: req.body.userId,
      pdf: pdfResult.url,
      name: req.body.name,
      mobileNo: req.body.mobileNo,
      branch: req.body.branch,
      classValue: req.body.classValue,
      division: req.body.division,
      photo: photoResult.url,
      status: 'Pending'

    });

    var saving = await document.save();
    // res.status(200).send(saving);
    res.status(200).json({ id: saving._id });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error saving document');
  }
});

app.get('/api/status/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    const user = await Document.findById(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json({ mobileNo: user.mobileNo, status: user.status });
  } catch (error) {
    console.error('Error fetching user status:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
});




app.use("/user", user);


const profileSchema = new mongoose.Schema({
  username: String,
  email: String,

});
const Profile = mongoose.model('studentlogins', profileSchema);

app.get('/profile/:id', async (req, res) => {
  const profileId = req.params.id;

  try {
    const profile = await Profile.findById(profileId);

    if (!profile) {
      return res.status(404).json({ error: 'Profile not found' });
    }
    res.json(profile);
  } catch (error) {
    console.error('Error fetching profile data:', error);
    res.status(500).json({ error: 'Failed to fetch profile data' });
  }
});


app.post('/api/studentData', async (req, res) => {
  try {
    const userId = req.body.userId;
    const document = await Document.findOne({ userId });

    if (!document) {
      return res.status(404).json({ message: 'User data not found' });
    }

    res.status(200).json(document);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving user data' });
  }
});



app.listen(3000, () => {
  console.log(`server on port 3000`)
})