<?php

// Include your database connection file
include 'db_connection.php';

// Check if the necessary parameters are provided
if (isset($_POST['userId'], $_POST['currentPassword'], $_POST['newPassword'])) {
    // Sanitize input data
    $userId = mysqli_real_escape_string($conn, $_POST['userId']);
    $currentPassword = mysqli_real_escape_string($conn, $_POST['currentPassword']);
    $newPassword = mysqli_real_escape_string($conn, $_POST['newPassword']);

    // Validate the current password against the database
    $query = "SELECT * FROM users WHERE id = '$userId' AND password = '$currentPassword'";
    $result = mysqli_query($conn, $query);

    if (mysqli_num_rows($result) > 0) {
        // Current password is correct, proceed with the update
        $updateQuery = "UPDATE users SET password = '$newPassword' WHERE id = '$userId'";
        if (mysqli_query($conn, $updateQuery)) {
            echo json_encode(array('success' => true, 'message' => 'Password updated successfully'));
        } else {
            echo json_encode(array('success' => false, 'message' => 'Password update failed'));
        }
    } else {
        // Current password is incorrect
        echo json_encode(array('success' => false, 'message' => 'Incorrect current password'));
    }
} else {
    // Invalid parameters
    echo json_encode(array('success' => false, 'message' => 'Invalid parameters'));
}

// Close the database connection
mysqli_close($conn);

?>