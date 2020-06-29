const express = require('express');
const verifyToken = require('../Helpers/verifytoken')
const bodyParser = require('body-parser')
const router = express.Router()
const Trans = require('../Models/Transaction')
const Meds = require('../Models/Meds')

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
        const r = Meds.findOne({ id: req.body.sid }).then(result => {
            // console.log(result.address)
            // console.log(result.Manufacture)
            const username = req.user.userName
            const trans = new Trans({

                transid: req.body.tid,
                name: username,
                from: updatedDoc1.to,
                to: result.address,
                sid: req.body.sid,
                eid: req.body.eid,
                medlist: req.body.medlist
                , dot: Date.now(),
                accepted: false,
                medname: req.body.medname,
                Toname: result.Manufacture,
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
                    // console.log(err)
                })

        })

    }).catch(err => {
        // console.log(err)
    })


});
module.exports = router
