import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("twitter:room", {})

channel.join()
	.receive("ok", resp => { console.log("Joined successfully", resp) })
	.receive("error", resp => { console.log("Unable to join", resp) })

function get_self_name(){
	var url=window.location.href;
	var parameters=url.split("/");
	return parameters[parameters.length-1];
}

setInterval(function(){
	let uname=get_self_name();
	if(uname!=""){
		channel.push("update_feed", {uname: uname});
	}
}, 5000);


if(document.getElementById("signup")){
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
	}
}

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

if(document.getElementById("signin")){
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
	}
}

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

if(document.getElementById("follow_btn")){
	document.getElementById("follow_btn").onclick= function() {
		let to_follow=document.querySelector("#to_follow");
		if(to_follow!=" "){
			channel.push("follow", {to_follow: to_follow.value, uname: get_self_name()});
		} else{
			alert("Enter a username before hitting follow!");
		}

		document.getElementById("to_follow")
			.addEventListener("keyup", function(event) {
				event.preventDefault();
				if (event.keyCode === 13) {
					document.getElementById("follow_btn").click();
				}
			});
	};
}

if(document.getElementById("tweet_btn")){
	document.getElementById("tweet_btn").onclick=function(){
		let content=document.querySelector("#tweet_content");
		if(content!=""){
			channel.push("tweet", {uname: get_self_name(), tweet: content.value});
		} else{
			alert("Please write something!");
		}
	};
}

channel.on("tweet_status", payload=>{
	let stat=payload.stat
	if(stat==1){
		alert("Tweet success!");
	}

});

channel.on("update_feed", payload => {
	let tweet_list=$("#feed_list").empty();
	var myTweets=payload.tweets;
	var arrayLength = myTweets.length;
	for (var i = 0; i < arrayLength; i++) {
		var btn = document.createElement("INPUT");
		btn.setAttribute('type', 'radio');
		btn.setAttribute('name', 'radioTweet');
		btn.setAttribute('tweeter', `${payload.tweets[i].tweeter}`);
		btn.setAttribute('tweet', `${payload.tweets[i].tweet}`);
		tweet_list.prepend(`${payload.tweets[i].tweeter}: ${payload.tweets[i].tweet}<br>`);
		tweet_list.prepend(btn);
	}

	tweet_list.scrollTop
});

export default socket
