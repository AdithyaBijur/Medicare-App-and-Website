const express = require('express');
const verifyToken = require('../Helpers/verifytoken')
const bodyParser = require('body-parser')
const router = express.Router()
const Trans = require('../Models/Transaction')

router.use(bodyParser())
router.use(bodyParser.json())
router.use(bodyParser.urlencoded({ extended: true }))

router.use(verifyToken)

router.post('/', (req, res) => {

    const re1 = Trans.findOneAndUpdate({ _id: req.body.Id }, { accepted: true }).then((updatedDoc1) => {
        // console.log("accept")
        res.status(200).send(updatedDoc1);
    }).catch(err => {
        // console.log(err)
    })

});
module.exports = router
