<?php
//error_reporting(0);
include_once("dbconnect.php");
$orderid = $_GET['orderid'];

$sqlloadorderdetails = "SELECT * FROM tbl_carts INNER JOIN tbl_books ON tbl_carts.book_id = tbl_books.book_id WHERE tbl_carts.order_id = '$orderid'";
$result = $conn->query($sqlloadorderdetails);

if ($result->num_rows > 0) {
    $orderdetaillist["orderdetails"] = array();
    while ($row = $result->fetch_assoc()) {
        $order = array();
        $order['cart_id'] = $row['cart_id'];
        $order['book_id'] = $row['book_id'];
        $order['cart_qty'] = $row['cart_qty'];
        $order['cart_status'] = $row['cart_status'];
        $order['book_title'] = $row['book_title'];
        $order['book_price'] = $row['book_price'];
        array_push( $orderdetaillist["orderdetails"],$order);
    }
    $response = array('status' => 'success', 'data' => $orderdetaillist);
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