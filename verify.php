<?php 
	$db = mysqli_connect("localhost","root","","userdata");
	if(!$db){
		echo "Database connect error".mysqli_error();
	}
	
	$id = $_GET['id'];
	$token = $_GET['token'];

	$select = "UPDATE login SET status = 1 WHERE id = '$id' AND token = '$token'";
	$result = mysqli_query($db,$select);
	if ($result) {
		echo json_encode("verify successful. you can log in now");
	}else{
		echo json_encode("not verifyed");
	}