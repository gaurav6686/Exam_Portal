const express = require('express')
const mongoose = require('mongoose')
const bodyparser = require('body-parser')
const cloudinary = require('cloudinary').v2;
const fileUpload = require('express-fileupload')
const path = require('path')
const app = express()
app.use(express.json())

mongoose.connect("mongodb+srv://Gauravd:gauravd@cluster0.hbhwc24.mongodb.net/",{
    useNewurlParser:true,
    useUnifiedtopology:true
  }).then(()=>{
    console.log("Connected With MongoDB");
}).catch((err)=>{
  console.log(`error is ${err}`);
})

const documentSchema = new mongoose.Schema({
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
      default:"Pendind"
    }
  });
  
  const Document = mongoose.model('studentdatas', documentSchema);
  module.exports = Document;

  
  
    app.use(express.json());
    
    cloudinary.config({
      cloud_name:'ds197oik9',
      api_key:'592329952254324',
      api_secret:'R_qJLiZmZzCoC3m4j3X66UJbZyo',
    });
  
    app.use(fileUpload({
      useTempFiles: true,
      limits: { fileSize: 100 * 1024 * 1024 }  }));


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
            pdf: pdfResult.url,
            name: req.body.name,
            mobileNo: req.body.mobileNo,
            branch:req.body.branch,
            classValue: req.body.classValue,
            division: req.body.division,
            photo: photoResult.url,
            status: 'Pending'
          });
      
          var saving = await document.save();
          res.status(200).send(saving);
        } catch (err) {
          console.error(err);
          res.status(500).send('Error saving document');
        }
      });
      



app.listen(3000, () => {
  console.log(`server on port 3000`)
})