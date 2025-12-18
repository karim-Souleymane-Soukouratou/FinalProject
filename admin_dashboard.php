<?php
session_start();
require_once 'db.php'; 

// 1. SECURITY: Access Control
$allowed_roles = ['SuperAdmin', 'Finance', 'Reviewer']; 

if (!isset($_SESSION['user_id']) || !isset($_SESSION['role'])) {
    header("Location: login.php");
    exit();
}

if (!in_array($_SESSION['role'], $allowed_roles)) {
    session_destroy();
    header("Location: login.php?error=unauthorized");
    exit();
}

// 2. DATA FETCHING
$admin_id = $_SESSION['user_id'];
$admin_role = $_SESSION['role'];

try {
    // Fetch Admin Username
    $stmt = $pdo->prepare("SELECT username FROM admin_users WHERE id = ?");
    $stmt->execute([$admin_id]);
    $admin = $stmt->fetch();

    // KPI: Total Paid This Year
    $stmt_paid = $pdo->query("SELECT SUM(amount) FROM payments WHERE status = 'Paid' AND YEAR(disbursement_date) = YEAR(CURDATE())");
    $total_paid = number_format($stmt_paid->fetchColumn() ?? 0, 0, '', ' ') . ' XOF';

    // KPI: Total Pending Payments Amount
    $stmt_pending = $pdo->query("SELECT SUM(amount) FROM payments WHERE status = 'Pending'");
    $total_pending = number_format($stmt_pending->fetchColumn() ?? 0, 0, '', ' ') . ' XOF';

    // KPI: Count Pending Payments
    $stmt_count = $pdo->query("SELECT COUNT(id) FROM payments WHERE status = 'Pending'");
    $count_pending = $stmt_count->fetchColumn();

    // KPI: Pending Bank Verifications
    $stmt_bank = $pdo->query("SELECT COUNT(id) FROM bank_details WHERE is_verified = 0");
    $count_bank_pending = $stmt_bank->fetchColumn();

    // KPI: Inactive Students
    $stmt_inactive = $pdo->query("SELECT COUNT(id) FROM students WHERE is_active = 0");
    $count_inactive = $stmt_inactive->fetchColumn();

} catch (PDOException $e) {
    die("Database Error: " . $e->getMessage());
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - ANAB Finance</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        :root {
            --orange: #F77F00; --green: #009E60; --red: #E31B23;         
            --white: #FFFFFF; --gray-bg: #f4f7f6; --dark: #333333;
        }

        body { font-family: 'Segoe UI', Arial, sans-serif; background-color: var(--gray-bg); margin: 0; }
        .dashboard-container { display: flex; min-height: 100vh; }

        /* Sidebar Styling */
        .sidebar {
            width: 260px; background-color: var(--dark); color: var(--white);
            padding: 20px; box-shadow: 2px 0 10px rgba(0,0,0,0.2); flex-shrink: 0;
        }
        .logo h2 { text-align: center; margin-bottom: 30px; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 15px; color: var(--orange); }
        .sidebar nav a { 
            display: block; padding: 12px 15px; color: var(--white); 
            text-decoration: none; margin-bottom: 8px; border-radius: 5px; transition: 0.3s;
        }
        .sidebar nav a:hover, .sidebar nav a.active { background-color: var(--orange); }
        .sidebar nav a i { margin-right: 10px; width: 20px; text-align: center; }

        /* Main Content Styling */
        .main-content { flex-grow: 1; padding: 40px; }
        .header { margin-bottom: 40px; }
        .header h1 { color: var(--green); margin: 0; }
        .header p { font-size: 1.1rem; color: #666; margin-top: 5px; }

        /* KPI Cards Grid */
        .kpi-cards { 
            display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); 
            gap: 25px; margin-bottom: 40px; 
        }
        .kpi-card {
            background-color: var(--white); padding: 25px; border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05); border-left: 6px solid;
            transition: transform 0.3s ease;
        }
        .kpi-card:hover { transform: translateY(-5px); }
        .kpi-card h3 { font-size: 0.85rem; color: #888; margin: 0 0 10px 0; text-transform: uppercase; }
        .kpi-value { font-size: 1.8rem; font-weight: bold; color: var(--dark); }
        .kpi-link { display: block; margin-top: 15px; font-size: 0.9rem; color: var(--green); text-decoration: none; font-weight: bold; }
        
        /* Card Colors */
        .kpi-card.paid { border-left-color: var(--green); }
        .kpi-card.pending { border-left-color: var(--orange); }
        .kpi-card.alert { border-left-color: var(--red); }
        .kpi-card.info { border-left-color: #3498db; }

        @media (max-width: 992px) {
            .dashboard-container { flex-direction: column; }
            .sidebar { width: 100%; }
            .sidebar nav { display: flex; flex-wrap: wrap; justify-content: center; }
        }
    </style>
</head>
<body>

<div class="dashboard-container">
    <aside class="sidebar">
        <div class="logo">
            <h2><i class="fas fa-university"></i> ANAB Admin</h2>
        </div>
        <nav>
            <a href="admin_dashboard.php" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
            
            <?php if ($admin_role === 'SuperAdmin' || $admin_role === 'Finance'): ?>
                <a href="payment_run.php"><i class="fas fa-money-check-alt"></i> Payment Run</a>
            <?php endif; ?>

            <a href="bank_verification.php"><i class="fas fa-check-double"></i> Bank Verification</a>
            <a href="add_student.php"><i class="fas fa-user-plus"></i> Add New Student</a>
            <a href="student_management.php"><i class="fas fa-users-cog"></i> Student Management</a>

            <?php if ($admin_role === 'SuperAdmin'): ?>
                <a href="create_admin.php" style="border: 1px dashed var(--orange);"><i class="fas fa-user-shield"></i> Create Admin</a>
            <?php endif; ?>

            <a href="logout.php" style="color: #ff6b6b; margin-top: 30px;"><i class="fas fa-power-off"></i> Logout</a>
        </nav>
    </aside>

    <main class="main-content">
        <header class="header">
            <h1>Welcome Back, <?php echo htmlspecialchars($admin['username'] ?? 'Admin'); ?>!</h1>
            <p>Role: <strong><?php echo htmlspecialchars($admin_role); ?></strong></p>
        </header>

        

        <div class="kpi-cards">
            <div class="kpi-card paid">
                <h3>Total Paid (<?php echo date('Y'); ?>)</h3>
                <span class="kpi-value"><?php echo $total_paid; ?></span>
                <a href="reports.php" class="kpi-link">Reports →</a>
            </div>

            <div class="kpi-card pending">
                <h3>Pending Amount</h3>
                <span class="kpi-value"><?php echo $total_pending; ?></span>
                <p><?php echo $count_pending; ?> scholars waiting.</p>
                <a href="payment_run.php" class="kpi-link">Process Run →</a>
            </div>

            <div class="kpi-card alert">
                <h3>Bank Verifications</h3>
                <span class="kpi-value"><?php echo $count_bank_pending; ?></span>
                <a href="bank_verification.php" class="kpi-link">Verify Now →</a>
            </div>

            <div class="kpi-card info">
                <h3>Inactive Scholars</h3>
                <span class="kpi-value"><?php echo $count_inactive; ?></span>
                <a href="student_management.php" class="kpi-link">Manage →</a>
            </div>
        </div>

        <section class="quick-access">
            <h2>Quick Actions</h2>
            <div style="display: flex; gap: 10px;">
                <a href="add_student.php" style="background: var(--green); color:white; padding: 15px; text-decoration:none; border-radius:5px;"><i class="fas fa-plus"></i> Add Student</a>
                <?php if ($admin_role === 'SuperAdmin'): ?>
                    <a href="create_admin.php" style="background: var(--dark); color:white; padding: 15px; text-decoration:none; border-radius:5px;"><i class="fas fa-user-shield"></i> New Admin</a>
                <?php endif; ?>
            </div>
        </section>
    </main>
</div>

</body>
</html>