<?php
session_start();
require_once 'db.php'; 

// Check if user is logged in and authorized
if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'SuperAdmin') {
    header("Location: login.php?error=unauthorized");
    exit();
}

$message = '';
$error = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $student_id = $_POST['student_id'];
    $first_name = $_POST['first_name'];
    $last_name = $_POST['last_name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $program = $_POST['program_name'];
    $university = $_POST['university_name'];
    // Default password for new students (they should change it later)
    $password_hash = password_hash('Student123!', PASSWORD_BCRYPT); 

    try {
        $stmt = $pdo->prepare("INSERT INTO students (student_id, first_name, last_name, email, password_hash, phone, program_name, university_name, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0)");
        $stmt->execute([$student_id, $first_name, $last_name, $email, $password_hash, $phone, $program, $university]);
        $message = "Student account created successfully! (Status: Inactive)";
    } catch (PDOException $e) {
        $error = "Error creating student: " . $e->getMessage();
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Student - ANAB Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root { --orange: #F77F00; --green: #009E60; --dark: #333; --white: #fff; }
        body { font-family: Arial, sans-serif; background: #f4f7f6; margin: 0; display: flex; }
        .sidebar { width: 250px; background: var(--dark); color: white; min-height: 100vh; padding: 20px; }
        .sidebar a { color: white; text-decoration: none; display: block; padding: 10px; margin: 5px 0; border-radius: 5px; }
        .sidebar a:hover { background: var(--orange); }
        .main-content { flex-grow: 1; padding: 40px; }
        .form-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); max-width: 600px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        .btn-submit { background: var(--green); color: white; border: none; padding: 12px 20px; cursor: pointer; border-radius: 5px; width: 100%; font-size: 1rem; }
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 5px; }
        .success { background: #d4edda; color: #155724; }
        .danger { background: #f8d7da; color: #721c24; }
    </style>
</head>
<body>
    <aside class="sidebar">
        <h2>ANAB Admin</h2>
        <a href="admin_dashboard.php"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="add_student.php" style="background: var(--orange);"><i class="fas fa-user-plus"></i> Add Student</a>
        <a href="logout.php"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </aside>

    <main class="main-content">
        <h1>Register New Scholar</h1>
        <div class="form-container">
            <?php if ($message): ?> <div class="alert success"><?php echo $message; ?></div> <?php endif; ?>
            <?php if ($error): ?> <div class="alert danger"><?php echo $error; ?></div> <?php endif; ?>

            <form method="POST">
                <div class="form-group"><label>Student ID (Scholarship Number)</label><input type="text" name="student_id" required></div>
                <div class="form-group"><label>First Name</label><input type="text" name="first_name" required></div>
                <div class="form-group"><label>Last Name</label><input type="text" name="last_name" required></div>
                <div class="form-group"><label>Email</label><input type="email" name="email" required></div>
                <div class="form-group"><label>Phone Number</label><input type="text" name="phone"></div>
                <div class="form-group"><label>Program Name</label><input type="text" name="program_name"></div>
                <div class="form-group"><label>University</label><input type="text" name="university_name" required></div>
                <button type="submit" class="btn-submit">Register Student</button>
            </form>
        </div>
    </main>
</body>
</html>