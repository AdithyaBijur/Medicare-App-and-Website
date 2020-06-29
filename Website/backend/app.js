const mongoose = require("mongoose")
const express = require("express")
const app = express()
const cors = require('cors')
app.use(cors())
app.use('/api', require('./Routes/index'))

// mongoose.connect("mongodb://localhost/medcare", { useNewUrlParser: true })
mongoose.connect("mongodb://moksh:moksh123@ds043324.mlab.com:43324/medsdapp", { useNewUrlParser: true })
    .then({
        // console.log("Hello")
    })
    .catch((err) => {
        // console.log(console.error("error" + err))
    });

app.listen(5000, () => console.log('Server started on port 5000'));

