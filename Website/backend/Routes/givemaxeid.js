const express = require('express');
const bodyParser = require('body-parser')
const router = express.Router()
const Meds = require('../Models/Meds')

router.use(bodyParser())
router.use(bodyParser.json())
router.use(bodyParser.urlencoded({ extended: true }))

router.post('/', (req, res) => {

    maxarr = [];
    const re1 = Meds.find({}).then((updatedDoc1) => {
        // console.log(updatedDoc1)
        const maxarrt = updatedDoc1.map((a) => {
            return a.id;
        })
        // const max = Math.max(...maxarrt)
        res.status(200).send(maxarrt);
    }).catch(err => {
        // console.log(err)
    })

});
module.exports = router
