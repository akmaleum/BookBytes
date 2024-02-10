<?php
$servername = "infnitvoid.com";
$username   = "infnidrc_akmal";
$password   = "h15yamDB_";
$dbname     = "infnidrc_bookbytes_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>