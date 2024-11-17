const express= require("express");
var http=require("http");
const app= express();
const port=process.env.PORT || 3000;
var server=http.createServer(app);
const mongoose = require("mongoose");
const {roommodel: Room }=require('./modules/Room.js');
const {playerSchema}=require('./modules/Player.js');
const getWord=require('./api/getWord.js');

var io= require("socket.io")(server);

app.use(express.json());

const DB='mongodb+srv://varadadhapre:W6MffBtiE46Str6f@skrib.bewac.mongodb.net/';
mongoose.connect(DB).then(()=>{
console.log("Connected to mongodb");
}).catch((e)=>{
    console.log(e);
});
try{
io.on('connection',(socket)=>{
    console.log('Connected: ', socket.id);
    console.log('connected');
    socket.on('create-game', async({nickname,name,occupancy,maxRounds})=>{
    try {
        console.log("In create game");
        const existingRoom= await Room.findOne({name});
        if(existingRoom){
            socket.emit('notCorrectGame','Room with that name Already exists');
            console.log('Existing room')
            return;
        }
        let room= new Room();
        const word= getWord();
        room.word=word;
        room.name=name;
        room.occupancy=occupancy;
        room.maxRounds=maxRounds;
        

        let player={
            socketID: socket.id,
            nickname: nickname,
            isPartyLeader:true,
        };
        room.players.push(player);
        console.log(`Player filled:`,JSON.stringify(player));
        
        room=await room.save();
        console.log("room save statement")
        io.to(name).emit('updateRoom',room);

        
    } catch (error) {
        console.log(error);
    }
});
socket.on('join-room',async({nickname,name})=>{
    try {
        let room= await Room.findOne({name});
        if(!room){
            socket.emit("notCorrectGame","Please enter valid room name");
        }
        if(room.isJoin){
            let player={
                socketID: socket.id,
                nickname: nickname,

            }
            room.players.push(player);
            socket.join(name);
            if(room.players.length===room.occupancy){
                room.isJoin=false;
            }
            room.turn = room.players[room.turnIndex];
            room=await room.save();
            io.to(name).emit('updateRoom',room);

        }
        else{
            socket.emit('notCorrectGame','The game is in progress.Please try later');
        }
    } catch (error) {
        console.log(error);
    }
});
socket.on('paint',({details,roomName})=>{
    io.to(roomName).emit('points',{details: details});
});
socket.on('color-change',({color, roomName})=>{
    io.to(roomName).emit("color-change",color);
});
});
}
catch(err){
    console.log(err);
}
server.listen(port,"0.0.0.0",()=>{
    console.log('Server running on port'+port);
});