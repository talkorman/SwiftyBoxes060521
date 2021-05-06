/**************************************************************************************************
 The model of the User for all users
 **************************************************************************************************/
const mongoose = require('mongoose');
const uniqueValidator = require("mongoose-unique-validator");

const userSchema = mongoose.Schema({
email: {type: String, required: true, unique: true},
password: {type: String, required: true},
resetToken: {type: String, required: false},
expireToken: {type: Date, required: false}
});

//make sure that no multiple emails using this library
userSchema.plugin(uniqueValidator);


module.exports = mongoose.model("User", userSchema); //User is the connection of all
                                                    //users to the Data Bases