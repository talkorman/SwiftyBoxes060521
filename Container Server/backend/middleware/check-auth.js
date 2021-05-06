/**************************************************************************************************
  This code is authorising the requests according to the Token, it's called on every data request.
  and running before the the final function that perform the request.
  **************************************************************************************************/
 const jwt = require("jsonwebtoken");
 module.exports = (req, res, next) => {
  console.log("checking auth");
   try{  
     //for choosing the word "Bearer" that comes before the token string
 const token = req.headers.authorization.split(" ")[1];  
 console.log("token: " + token);
 const decodedToken = jwt.verify(token, "the secret word"); //this method also throws an error. it checks if the token was generated by the secret word authorised
 req.userData = {email: decodedToken.email, userId: decodedToken.userId}; //here the info updated with additional field userId
 console.log("passed token");
 next(); //will let the execution to continue add the new fields mentioned below from express js
   }catch (error){

     console.log("error");
       res.status(401).json({
           message: "You're not logged in",
           result: res.status

       });
   }
 };