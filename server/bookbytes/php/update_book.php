<?php
//error_reporting(0);

if (!isset($_POST['userid']) && !isset($_POST['isbn']) && !isset($_POST['title'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$bookid = $_POST['bookid'];
$userid = $_POST['userid'];
$isbn = $_POST['isbn'];
$title = addslashes($_POST['title']);
$desc = addslashes($_POST['desc']);
$author = addslashes($_POST['author']);
$price = $_POST['price'];
$qty = $_POST['qty'];
$status = $_POST['status'];
$image = $_POST['image'];
if ($image != "NA"){
    $decoded_string = base64_decode($image);
}

$sqlupdate = "UPDATE `tbl_books` SET `book_isbn`='$isbn',`book_title`='$title',`book_desc`='$desc',`book_author`='$author',`book_price`='$price',`book_qty`='$qty',`book_status`='$status' WHERE `book_id` = '$bookid'";

if ($conn->query($sqlupdate) === TRUE) {
    if ($image != "NA"){
        $path = '../assets/books/' . $bookid  . '.png';
        file_put_contents($path, $decoded_string);
    }
	$response = array('status' => 'success', 'data' => null);
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