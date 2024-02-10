<?php
// update_password.php

// Include your database connection file
include('db_connection.php');

// Assume your users table has columns: userid, userpassword

// Get user ID and new password from the POST request
$userId = $_POST['userId'];
$newPassword = $_POST['newPassword'];

// Validate user ID and new password
if (empty($userId) || empty($newPassword)) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input']);
    exit();
}

// Hash the new password (you should use a secure hashing algorithm)
$hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

// Update the password in the database
$updateQuery = "UPDATE users SET userpassword = '$hashedPassword' WHERE userid = '$userId'";

if (mysqli_query($conn, $updateQuery)) {
    echo json_encode(['status' => 'success', 'message' => 'Password updated successfully']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to update password']);
}

// Close the database connection
mysqli_close($conn);
?>