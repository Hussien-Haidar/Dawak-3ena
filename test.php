<?php
include 'config.php';

$id = 0;
$name = $_POST['name'];
$email = $_POST['email'];

$result = mysqli_query($con, "SELECT medicines.*, pharmacists.*,
medicines.id AS id FROM medicines
JOIN pharmacists ON medicines.id_pharmacist = pharmacists.id
WHERE name LIKE '%$name%' and amount>0 ORDER BY medicines.name;");

$result2 = mysqli_query($con, "SELECT * FROM users where email='$email'");
if ($row = mysqli_fetch_array($result2)) {
    $id = $row['id'];
}

$data = array();
$saved_medicines = array();

if (mysqli_num_rows($result) > 0) {

    $result3 = mysqli_query($con, "Select * from saved_medicines where id_users = '$id'");

    while ($row2 = $result3->fetch_assoc()) {
        $saved_medicines[] = $row2['id_medicines'];
    }

    while ($row3 = $result->fetch_assoc()) {
        $data[] = $row3;
    }
    $response["success"] = true;
    $response["data"] = $data;
    $response["saved_medicines"] = $saved_medicines;
} else {
    $response["success"] = false;
}

echo json_encode($response);
