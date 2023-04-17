<?php
include 'config.php';

date_default_timezone_set('Asia/Beirut'); // set the timezone to Lebanon
$lebanonTime = new DateTime(); // get the current time
$lebanonTime->setTimezone(new DateTimeZone('Asia/Beirut')); // set the timezone to Lebanon

$id_user;
$uid = $_POST["uid"];
$full_name = $_POST["full_name"];
$email = $_POST["email"];
$push_token = $_POST["push_token"];
$created_at = $lebanonTime->format('d/m/Y');

$sql = "SELECT * FROM users WHERE BINARY email = '$email'";
$result = mysqli_query($con, $sql);

if($row = mysqli_fetch_array($result)) {
    $id_user = $row['id'];
    $response["exist"] = true;
    $sql2 = "UPDATE users SET uid='$uid' WHERE email='$email'";
    $result2 = mysqli_query($con, $sql2);
} 
else {
    $response["exist"] = false;
    $sql2 = "INSERT INTO users (uid, full_name, email, created_at) values 
    ('$uid', '$full_name', '$email', '$created_at')";
    $result2 = mysqli_query($con, $sql2);

    $sql2 = "SELECT * FROM users WHERE BINARY email = '$email'";
    $result2 = mysqli_query($con, $sql2);
    if($row2 = mysqli_fetch_array($result2)) {
        $id_user = $row2['id'];
    } 
}

$sql3 = "SELECT push_tokens.*, users.* FROM push_tokens
JOIN users ON push_tokens.id_user = users.id
WHERE push_tokens.id_user='$id_user'";
$result3 = mysqli_query($con, $sql3);

if(!$row3 = mysqli_fetch_array($result3)) {
    $sql4 = "UPDATE push_tokens SET push_token='$push_token' WHERE id_user='$id_user'";
    $result4 = mysqli_query($con, $sql4);
}

else{
    $sql4 = "INSERT INTO push_tokens (id_user, push_token) values ('$id_user','$push_token')";
    $result4 = mysqli_query($con, $sql4);
}

echo json_encode($response);
