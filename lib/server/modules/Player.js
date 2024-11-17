const mongoose=require('mongoose');

const playerSchema= new mongoose.Schema({
    nickname:{
        required:true,
        type:String,
        trim:true
    },
    socketID:{
        type:String
    },
    isPartyLeader:{
        type:Boolean,
        default:false
    },
    points:{
        type:Number,
        default:0

    }
});

 
module.exports={
    playerSchema
};