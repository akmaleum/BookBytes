<?php
//error_reporting(0);
include_once("dbconnect.php");
$sellerid = $_GET['sellerid'];
$sqlloadorders = "SELECT * FROM `tbl_orders` INNER JOIN tbl_users ON tbl_orders.buyer_id = tbl_users.user_id WHERE tbl_orders.seller_id = '$sellerid'";
$result = $conn->query($sqlloadorders);

if ($result->num_rows > 0) {
    $orderlist["orders"] = array();
    while ($row = $result->fetch_assoc()) {
        $order = array();
        $order['order_id'] = $row['order_id'];
        $order['buyer_id'] = $row['buyer_id'];
        $order['seller_id'] = $row['seller_id'];
        $order['order_total'] = $row['order_total'];
        $order['order_date'] = $row['order_date'];
        $order['order_status'] = $row['order_status'];
        $order['user_email'] = $row['user_email'];
        $order['user_name'] = $row['user_name'];
        array_push( $orderlist["orders"],$order);
    }
    $response = array('status' => 'success', 'data' => $orderlist);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>