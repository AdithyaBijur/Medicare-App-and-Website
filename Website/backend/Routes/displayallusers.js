const express = require('express');
const verifyToken = require('../Helpers/verifytoken')
const jwt = require('jsonwebtoken');
const config = require('../config');
const bodyParser = require('body-parser')
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs")
const user = require("../Models/User")
const router = express.Router()

router.use(bodyParser())
router.use(bodyParser.json())
router.use(bodyParser.urlencoded({ extended: true }))

router.post('/', (req, res) => {

  const re1 = user.find({}).then((updatedDoc1) => {

    res.send(updatedDoc1);
  }).catch(err => {
    // console.log(err)
  })


});
module.exports = router
