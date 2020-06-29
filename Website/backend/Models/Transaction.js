var mongoose = require('mongoose');
const Schema = mongoose.Schema({
    transid: String,
    from: String,
    to: String,
    sid: Number,
    eid: Number,
    meds: Number,
    dot: Date,
    name: String,
    accepted: Boolean,
    Toname: String,
    medlist: Array,
    exp: Date,
    msg: String,
    medname: String

})

const Trans = mongoose.model('Trans', Schema)
module.exports = Trans;