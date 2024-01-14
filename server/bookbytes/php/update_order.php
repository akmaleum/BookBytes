<?php
//error_reporting(0);

if (!isset($_POST['orderid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$orderid = $_POST['orderid'];
$orderstatus = $_POST['orderstatus'];

$sqlupdate = "UPDATE `tbl_orders` SET `order_status`='$orderstatus' WHERE `order_id` ='$orderid'";

if ($conn->query($sqlupdate) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlupdate);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => $sqlupdate);
	sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>