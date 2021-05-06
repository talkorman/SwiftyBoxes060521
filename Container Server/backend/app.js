/**************************************************************************************************
 The main code that route the requests.
 **************************************************************************************************/
const express = require('express');
const bodyParser = require('body-parser');
const mongoose = require("mongoose");
const postsRoutes = require("./routes/posts");
const userRoutes = require("./routes/user");
const algoRoutes = require("./routes/algorithm");
const app = express();

mongoose.connect("mongodb+srv://talkorman: /*Here comes The MongoDB code*/ @cluster0.8n6ej.mongodb.net/Cluster0?retryWrites=true", { useNewUrlParser: true,  useUnifiedTopology: true})
.then(() => {
    console.log('Connected to database!')
})
.catch((e) => {
    console.log("Connection failed! " + e);
});
app.use(bodyParser.json()); //for parsing json data
app.use(bodyParser.urlencoded({extended: true})); //for parsing url data

//to prevent CORS which is an error of host address missmatch
app.use((req, res, next) => {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Headers", "Origin, X-Request-With, Content-Type, Accept, Authorization");
    res.setHeader("Access-Control-Allow-Methods", "GET, POST, PATCH, PUT, DELETE, OPTIONS");
    next(); // to be able to continue to the next one
});

app.get('/', (req, res) =>{
    console.log("Hello");
})

app.use("/api/posts", postsRoutes);
app.use("/api/user", userRoutes);
app.use("/api/algorithm", algoRoutes);
module.exports = app;       //connecting the express with the nodeJS