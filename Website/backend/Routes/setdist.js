const express = require("express");
const mongoose = require("mongoose");
var bodyParser = require('body-parser')
const bcrypt = require('bcryptjs');
const verifyToken = require('../Helpers/verifytoken')
const saltRounds = 10;
const us = require("underscore");
var validator = require("email-validator");
const User = require("../Models/User")
const Trans = require('../Models/Transaction')
const Meds = require('../Models/Meds')
const router = express.Router();
router.use(bodyParser())

router.use(bodyParser.urlencoded({ extended: true }));
router.use(bodyParser.json())

router.use(verifyToken)

router.post('/', (req, res) => {
    const username = req.user.userName
    if (req.body.acc == undefined) {
        res.send().json({ "msg": "login in to meta mask" });
    }
    console.log(req.body.acc);
    const trans = new Trans({
        medname: req.body.medname,
        transid: req.body.tid,
        name: username,
        from: req.body.acc,
        to: req.body.to,
        Toname: req.body.toname,
        sid: req.body.sid,
        eid: req.body.eid,
        meds: req.body.eid - req.body.sid + 1
        , dot: Date.now(),
        accepted: false


    })
    trans.save()
        .then(

            resu => {
                // console.log(resu); 
                res.status(200).send(resu);
            }
        )
        .catch(err => {
            // console.log(err)
        })

});

module.exports = router;