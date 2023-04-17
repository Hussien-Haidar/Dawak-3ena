<?php
include 'config.php';

$email = $_POST['email'];
$medicine = $_POST['medicine'];
$pharmacy = $_POST['pharmacy'];

$res = mysqli_query($con, "SELECT * from users where email='$email'");

$res2 = mysqli_query($con, "SELECT medicines.*, pharmacists.pharmacy_name,
medicines.id AS id FROM medicines
JOIN pharmacists ON medicines.id_pharmacist = pharmacists.id
WHERE pharmacists.pharmacy_name='$pharmacy' and medicines.name='$medicine'");

if ($row = mysqli_fetch_array($res)) {
    $id_user = $row['id'];
}
if ($row2 = mysqli_fetch_array($res2)) {
    $id_medicine = $row2['id'];
}

$res3 = mysqli_query($con, "SELECT * from saved_medicines where id_users=$id_user and id_medicines = $id_medicine");

if ($row3 = mysqli_fetch_array($res3)) {
    $response["action"] = "removed";
    $response["message"] = "Removed from Saved";
    $response["data"] = $id_medicine;

    $res4 = mysqli_query($con, "DELETE FROM saved_medicines
    WHERE id_users='$id_user' and id_medicines='$id_medicine'");
} else {
    $response["action"] = "saved";
    $response["message"] = "saved successfuly";
    $response["data"] = $id_medicine;

    $res4 = mysqli_query($con, "Insert INTO saved_medicines(id_users, id_medicines) 
    values('$id_user', '$id_medicine')");
}

echo json_encode($response);
