<?php
//error_reporting(0);

if (!isset($_POST['buyer_id'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$buyer_id = $_POST['buyer_id'];
$seller_id = $_POST['seller_id'];
$book_id = $_POST['book_id'];
$cart_qty = "1";
$cart_status = "New";

$sqlinsert = "INSERT INTO `tbl_carts`(`buyer_id`, `seller_id`, `book_id`, `cart_qty`, `cart_status`) VALUES ('$buyer_id','$seller_id','$book_id','$cart_qty','$cart_status')";

if ($conn->query($sqlinsert) === TRUE) {
	$response = array('status' => 'success', 'data' => $sqlinsert);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => $sqlinsert);
	sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>