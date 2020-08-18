<?php 
	$db = mysqli_connect("localhost","root","","userdata");
	if(!$db){
		echo "Database connect error".mysqli_error();
	}
	
	$username = $_POST['username'];
	$password = $_POST['password'];
	
	$select = $db->query("SELECT * FROM login WHERE username = '".$username."' AND password = '".$password."' AND status = 1");
	$count = mysqli_num_rows($select);
	if($count == 1){
		echo json_encode("OKK");
	}else{
		echo json_encode("NOTOKK");
	}