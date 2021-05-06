/**************************************************************************************************
 This code perform the update, uploading, downloading and viewing of the packing lists on the Data base.
 **************************************************************************************************/
const express = require("express");
const router = express.Router();
const Post = require('../models/post');
const stringComparison = require('string-comparison');
const checkAuth = require("../middleware/check-auth"); //using auth only on posts and location calculations
const { cosine } = require("string-comparison");
                        

const cos = stringComparison.cosine;

router.post("/post", checkAuth, (req, res, next) => {
    const post = new Post({
        label: req.body.label,
        packingList: req.body.packingList,
        container: req.body.container,
        creator: req.userData.userId//could take the field of userData.userId that added at auth by the help of express js
    });
    post.save().then(result => {
        console.log("saved");
        return res.status(202).json({
            message: "new post created"
        })
    });
});

router.put("/put", checkAuth, (req, res, next) => {
    Post.updateOne({label: req.body.label}, req.body)
    .then(result => {
        result = req.body.packingList;
return res.status(204).json({
            message: "Update successfully!",
            result: res.status
    });
  
    });
});


router.get("", checkAuth, (req, res, next) => {
    console.log(req.query);
    const postQuery = Post.find();
    let fetchPosts;
    postQuery.then(documents => {
      fetchPosts = documents;
      res.status(200).json({
          message: fetchPosts,
          result: res.status
      });
  });
    return res.status(200).json({});
    
});
//return all the posts
router.get("/view", checkAuth, (req, res, next) => {
    console.log("posts viewing request");
    Post.find().then(post => {
        if(post){
            const arr = [];
            for (let i = 0; i < post.length; i++){
                console.log(post[i].creator + " " + req.userData.userId);  
                const label = post[i].label;
                const id = post[i]._id;
            if(post[i].creator == req.userData.userId){
                 arr.push({label, id});
            };     
            };
            console.log("views: " + arr);
            res.status(200).json({
                message: arr,
                result: res.status
            });
        }else{
            res.status(404).json({message: 'No users on server'});
        }
    })
})
router.get("/:id", checkAuth, (req, res, next) => {
    console.log("getting");
    Post.find().then(post => {
        for(let i = 0; i < post.length; i++){
            if(post[i]._id == req.params.id){
                    return post[i];
                }
            }
        }).then(result => {
            console.log(result);
            res.status(200).json({
                label: result.label,
                packingList: result.packingList,
                container: result.container
            });
        });
});
router.delete("/:id", checkAuth, (req, res, next) =>{
    Post.deleteOne({_id: req.params.id}).then(result =>{
        console.log(result)
        res.status(200).json({message: req.params.name + " was deleted!"})
    });
    
});

module.exports = router;