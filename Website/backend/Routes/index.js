const express = require('express');
const router = express.Router()

router.use('/login', require('./login'))
router.use('/signup/', require('./signup'))
router.use('/getuser/', require('./getuser'))
router.use('/getalluser/', require('./getalluser'))
router.use('/displayallusers/', require('./displayallusers'))
router.use('/addmed/', require('./addmeds'))
router.use('/getnotifs/', require('./getnotification'))
router.use('/gettrans/', require('./gettransaction'))
router.use('/accept/', require('./accept'))
router.use('/reject/', require('./reject'))
router.use('/acceptmeds/', require('./acceptmed'))
router.use('/rejectmeds/', require('./rejectmed'))
router.use('/backtrack/', require('./backtrack'))
router.use('/setdist/', require('./setdist'))
router.use('/updatenot/', require('./updatenot'))
router.use('/sell/', require('./sell'))
router.use('/givemaxeid/', require('./givemaxeid'))
router.use('/checkforusername/', require('./check_username_exist'))


module.exports = router