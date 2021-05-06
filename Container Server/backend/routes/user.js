/**************************************************************************************************
 Handling the users register, login, password reset and the users information on the Data base. 
 **************************************************************************************************/
const express = require("express");
const bcrypt = require("bcrypt");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");
const nodeMailer = require("nodemailer");
const User = require("../models/user");
const { error } = require("console");
const user = require("../models/user");
const checkAuth = require("../middleware/check-auth");
const { getMaxListeners } = require("../models/user");
const router = express.Router();
const fs = require("fs");
let resetToken = '';
let resetPass = false;
let userUpdateId;
const transporter = nodeMailer.createTransport({
    host: 'smtp.126.com',
    port: 465,
    secure: true,
    auth:{
        user: 'talkorman@126.com',
        pass: 'secretwords'
    }
});
router.post("/sendPassword", (req, res, next) => {
    crypto.randomBytes(32,(err, buffer)=>{
        if(err){
            console.log(err);
        }
        const token = buffer.toString('hex');
        resetToken = token;
        User.findOne({email: req.body.email})
        .then(user => {
            if (!user){
                res.status(404).json(message => {
                    message: "user not found"
                    result: 404

                });
                console.log("no user");
                return;
            };
            userUpdateId = user._id;
            user.resetToken = token;
            user.expireToken = Date.now() + 3600000;
            user.save().then(result => {
             transporter.sendMail({
                 from: 'talkorman@126.com',
                to: user.email,
                subject: 'reset password',
                html: `<p>you have requested to reset your password</p> 
                         <h5>please click on this <a href="https://swiftyboxes.herokuapp.com/api/user/reset/${token}">link</a> 
                         to reset your password</h5>`
             });
                    res.status(203).json({
                    message: "check your email to reset password",
                    result: res.status
                })
                });
                
            })
        })
    })
router.get("/reset/:token", (req, res, next) => {
    if(req.params.token === resetToken){
    res.writeHead(200, { 'Content-Type': 'text/html' });
        res.write(`
        <br><br><br><br>
        <h3 style.fontFamily = 'Arial'>please input a new password<h3>
        <input placeholder="Enter password" type="password" name="email" id="pass1" required>
        <br><br>
        <input placeholder="Re enter password" type="password" name="email" id="pass2" required>
        <br><br>
        <button onClick = check()>submit</button>   
        <h5 id="message"></h5>
        <style>
        h3, input, button, h5{
            color: blue;
            text-align: center;
        }
        #message{
            color: red;
        }
        </style>
        <script>
       
        function validate(pass) {
            const rgx = /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,16}$/;
            return rgx.test(String(pass));
        };
         function check(){
        console.log("check");
            let pass1 = document.getElementById('pass1').value;
            let pass2 = document.getElementById('pass2').value;
            let message = document.getElementById('message');
            console.log(pass1);
            if(!validate(pass1)){
                message.textContent = "email should contain at least 6 digits, low case, upper case, number and symbols";
            }
            if(
                pass1 == pass2 &&
                validate(pass1) &&
                validate(pass2)
            ){
            message.textContent = "Processing";
            fetch('/api/user/newPass', {
            method: 'POST',
            mode: 'cors',
            body: JSON.stringify({pass: pass1}),
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json'
            }
        })
        .then(response => message.textContent = "Your password is updated")
        .catch(response => message.textContent = "problem to update your password, email us");
            }
        }
        </script>
        `);
        res.end();
    
        console.log("equal");
       resetPass = true; 
    }
})
router.post("/newPass", (req, res, next) =>{
    bcrypt.hash(req.body.pass, 10)  
    .then(hash => {                   
    user.findByIdAndUpdate({_id : userUpdateId}, {password : hash}, {new : true})
    .then(err => { 
        if(err){
        return res.status(404).json({
            message: "coul not update, please send us email", 
            result: res.status
        })}else{
            return res.status(202).json({
                message:"username updated", 
                result: res.status});
        };
        });
});   
     });
router.post("/signup", (req, res, next) => {
    bcrypt.hash(req.body.password, 10)  //protecting the password in the server by encrypting by 10
    .then(hash => {                     //insted of the 3rd parameter function can run the promise
        const user = new User({
    email: req.body.email,
    password: hash
});
user.save()                             //saving the new user to the Data Base
.then(result => {                       //callback as promiss after saving the user
    res.status(201).json({
        message: "The new user created",
        result: res.status
    });
})
.catch(err => {
    res.status(403).json({
        error: err
    });
});
    });

});

router.post("/login", (req, res, next) =>{
console.log("try to login with the data: " + req.body.email + " " + req.body.password);
let fetchUser;
let status;
let dontSend = false //to prevent multi res at a time
User.findOne({email: req.body.email})   //the User is the connection to the Data Base
.then(user => {
    if(!user){
        dontSend = true;
        status = 404;
        console.log("user not found");
        return res.status(404).json({   
               message: "user not exist",
               result: res.status
        });
    };
    console.log("user was found");
    fetchUser = user;
    //because we hashed the password, we need to debycrypt it
    return bcrypt.compare(req.body.password, user.password);
    //this part will return another promiss after the comparison and then:
})
.then(result =>{    //the rusult of the comparison which is boolean
    if(!result && !dontSend){
        status = 402
        return res.status(402).json({
            message:"password not correct",
            result: res.status
        });
    };
    
    console.log("succeed");
    const token = jwt.sign({email: fetchUser.email, userId: fetchUser._id}, 
        'secretwords', {expiresIn: "1h"}); //after 1h the token will expire
    //sending the generated token to the backend
   return res.status(200).json({
        message: token,
        result: res.status
    })
})
.catch(err => {
    if(!dontSend){
    return res.status(402).json({
        message: "the password is not correct",
        result: res.status
    });
}
})
});

module.exports = router;