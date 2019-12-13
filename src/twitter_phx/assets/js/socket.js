import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("twitter:lobby", {})

channel.join()
	.receive("ok", resp => { console.log("Joined successfully", resp) })
	.receive("error", resp => { console.log("Unable to join", resp) })

document.getElementById("signup").onclick = function() {
	let uname=document.querySelector("#uname");
	let passwd=document.querySelector("#passwd");

	if(passwd.value != "" || uname.value != ""){
		channel.push("signup", {uname: uname.value, passwd: passwd.value});
	}
	else{
		alert("Empty username or password not allowed")
	}
	uname.value = "";
	passwd.value = "";
};

channel.on("signup_result", payload=>{
	let result=payload["res"];
	let uname=payload["uname"];

	if(result==true){
		alert("User "+uname+" successfully signed up!");
	}
	else{
		alert("Error!!");
	}
});

document.getElementById("signin").onclick = function() {
	let uname=document.querySelector("#uname");
	let passwd=document.querySelector("#passwd");

	if(passwd.value != "" || uname.value != ""){
		channel.push("signin", {uname: uname.value, passwd: passwd.value});
	}
	else{
		alert("Empty username or password not allowed")
	}
	uname.value = "";
	passwd.value = "";
};

channel.on("signin_result", payload=>{
	let result=payload["res"];
	let uname=payload["uname"];

	if(result==true){
		window.location.href="http://127.0.0.1:4000/home/"+uname;
	}
	else{
		alert("Error!!");
	}
});

export default socket
