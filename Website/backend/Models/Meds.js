var mongoose = require('mongoose');
const Schema = mongoose.Schema({
    Name:String,
    Manufacture:String,
    address:String,
    expiry:Date,
    id:Number

})

const Meds = mongoose.model('Meds', Schema)
module.exports = Meds;