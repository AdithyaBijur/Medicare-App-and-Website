const express = require('express');
const bodyParser = require('body-parser')
const router = express.Router()
const user = require("../Models/User")

router.use(bodyParser())
router.use(bodyParser.json())
router.use(bodyParser.urlencoded({ extended: true }))

router.post('/', (req, res) => {

    const re1 = user.find({ userName: req.body.username }).then((updatedDoc1) => {

        res.status(200).send(updatedDoc1);
    }).catch(err => {
        // console.log(err)
    })

});
module.exports = router
