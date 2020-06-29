var mongoose = require('mongoose');
const Schema = mongoose.Schema({
    email: String,
    password: String,
    phone: String,
    name: String,
    LcNo: String,
    userName: String,
    address: String,
    typeofuser: String,
    accepted: Boolean,
    city: String

})

const User = mongoose.model('User', Schema)
module.exports = User;