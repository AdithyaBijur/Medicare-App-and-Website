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
    // console.log(req.body.acc);
    const trans = new Trans({

        transid: req.body.tid,
        name: username,
        from: req.body.acc,
        to: req.body.to,
        sid: req.body.sid,
        eid: req.body.eid,
        medlist: req.body.medlist
        , dot: Date.now(),
        accepted: false,
        Toname: req.body.toname,
        exp: req.body.exp
        , meds: req.body.medlist.length,
        medname: req.body.name

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

    for (i = req.body.sid; i <= req.body.eid; i++) {
        const meds = new Meds({


            Name: req.body.name,
            Manufacture: username,
            address: req.body.acc,
            expiry: req.body.exp,
            id: i


        })
        meds.save()
            .then(

                resu => {
                    // console.log(resu);
                    res.status(200).send(resu);
                }
            )
            .catch(err => {
                // console.log(err)
            })
    }

});

// const port = process.env.PORT || 1080;

//string _medName,uint sid,uint lid,address _to
// router.listen(port, () => console.log(`Listening on port ${port}...`));
module.exports = router;
