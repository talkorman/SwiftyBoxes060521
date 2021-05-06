const mongoose = require('mongoose');

const packageSchema = new mongoose.Schema({
    name: {type: String, required: true},
    qty:{type: Number, required:true},
    length:{type: Number, required: true},
    width:{type: Number, required: true},
    height:{type: Number, required: true},
    weight:{type: Number, required: true}
})

module.exports = packageSchema;