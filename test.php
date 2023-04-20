<?php
include 'config.php';

$email = $_POST['email'];

$data = array();

$res = mysqli_query($con, "SELECT * from notifications where destination='user' or destination='both'");

while ($row = mysqli_fetch_array($res)) {
    $data[] = $row;
}
$response["data"] = $data;


echo json_encode($response);
