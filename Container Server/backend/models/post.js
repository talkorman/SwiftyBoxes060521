/**************************************************************************************************
 The model of the Posts used as a model of the packing list received and sent to the user and as a 
 model of the data result from the algoritm that will be returned to the front end.
 **************************************************************************************************/
const mongoose = require('mongoose');


const postSchema = mongoose.Schema({
label: {type: String, required: true},
packingList:{type:mongoose.Schema.Types.Array},
container: {type: String, required: true},
creator: {type: mongoose.Schema.Types.ObjectId, ref: "User", required: true} //to reffer the post to the specific user who created it
});


module.exports = mongoose.model("Post", postSchema);