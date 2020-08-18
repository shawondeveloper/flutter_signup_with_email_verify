<?php 
	$db = mysqli_connect("localhost","root","","userdata");
	if(!$db){
		echo "Database connect error".mysqli_error();
	}
	
	$username = $_POST['username'];
	$password = $_POST['password'];

	$token = md5(rand('10000', '99999'));
	
	$insert = $db->query("INSERT INTO login(username,password,token)VALUES('".$username."','".$password."','".$token."')");
	if($insert){
		$lastId = mysqli_insert_id($db);

		$url = 'http://'.$_SERVER['SERVER_NAME'].'/flutter-signup-with-email-verify/verify.php?id='.$lastId.'&token='.$token; 

		
		//$output = '<div>Thanks for registering with Flutter localhost. Please click this link to complete this registation <br>'.$url.'</div>';
		
		echo json_encode($url);
	}