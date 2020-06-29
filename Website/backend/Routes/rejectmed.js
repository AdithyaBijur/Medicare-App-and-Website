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

    // console.log(req.body.Id)
    const re1 = Trans.findOneAndDelete({ _id: req.body.Id }, { accepted: false }).then((updatedDoc1) => {
        // console.log("reject *****************************")
        // console.log(updatedDoc1)
        res.status(200).send(updatedDoc1);
        const username = req.user.userName
        const trans = new Trans({

            transid: req.body.tid,
            name: username,
            from: updatedDoc1.to,
            to: updatedDoc1.from,
            sid: req.body.sid,
            eid: req.body.eid,
            medname: req.body.medname,
            medlist: req.body.medlist
            , dot: Date.now(),
            accepted: false,
            Toname: updatedDoc1.name,
            exp: updatedDoc1.exp
            , meds: req.body.medlist.length,
            msg: 'Your has been declined by the reciever'

        })
        trans.save()
            .then(

                resu => {
                    // console.log(resu); 
                    res.status(200).send(resu);
                }
            )
            .catch(err => {
                //  console.log(err)
            })

    }).catch(err => {
        // console.log(err)
    })

});
module.exports = router