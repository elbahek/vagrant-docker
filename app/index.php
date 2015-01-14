<?php

$hostIp = '172.16.1.10';
$mysqlException = null;
$mysqlSuccess = false;
try {
    $conn = new PDO('mysql:host='. $hostIp, 'admin', 'XfDY7X2pNrwoU07Q0PNT');
    $conn->query('SELECT 1');
    $conn = null;
    $mysqlSuccess = true;
}
catch (Exception $e) {
    $mysqlException = $e->getMessage();
}

$mysqlProxyException = null;
$mysqlProxySuccess = false;
try {
    $conn = new PDO('mysql:host='. $hostIp .';port=4040', 'admin', 'XfDY7X2pNrwoU07Q0PNT');
    $conn->query('SELECT 1, "mysql_proxy"');
    $conn = null;
    $mysqlProxySuccess = true;
}
catch (Exception $e) {
    $mysqlProxyException = $e->getMessage();
}

try {
    $conn = new PDO('mysql:host='. $hostIp, 'admin', 'XfDY7X2pNrwoU07Q0PNT');
    $conn->query('SELECT 1');
    $conn = null;
    $mysqlSuccess = true;
}
catch (Exception $e) {
    $mysqlException = $e->getMessage();
}

$memcachedException = null;
$memcachedSuccess = false;
try {
    $mc = new Memcached();
    $mc->addServer($hostIp, 11211);
    $mc = null;
    $memcachedSuccess = true;
}
catch (Exception $e) {
    $memcachedException = $e->getMessage();
}
?>

<div style="position: relative; width: 100%">
    <div style="box-sizing: border-box; padding: 10px 15px; position: relative; width: 600px; left: 50%; margin-left: -300px; margin-bottom: 30px; background-color: <?= $mysqlSuccess ? '#5cb85c': '#d9534f' ?>">
        <h4 style="margin-top: 0px;">Mysql connection <?= $mysqlSuccess ? 'success' : 'failure' ?></h4>
        <?php if (!$mysqlSuccess) { ?>
            <div><?= $mysqlException ?></div>
        <?php } ?>
    </div>
</div>

<div style="position: relative; width: 100%">
    <div style="box-sizing: border-box; padding: 10px 15px; position: relative; width: 600px; left: 50%; margin-left: -300px; margin-bottom: 30px; background-color: <?= $mysqlSuccess ? '#5cb85c': '#d9534f' ?>">
        <h4 style="margin-top: 0px;">Mysql proxy connection <?= $mysqlProxySuccess ? 'success' : 'failure' ?></h4>
        <?php if (!$mysqlProxySuccess) { ?>
            <div><?= $mysqlProxyException ?></div>
        <?php } ?>
    </div>
</div>

<div style="position: relative; width: 100%">
    <div style="box-sizing: border-box; padding: 10px 15px; position: relative; width: 600px; left: 50%; margin-left: -300px; margin-bottom: 30px; background-color: <?= $memcachedSuccess ? '#5cb85c': '#d9534f' ?>">
        <h4 style="margin-top: 0px;">Memcached connection <?= $memcachedSuccess ? 'success' : 'failure' ?></h4>
        <?php if (!$memcachedSuccess) { ?>
            <div><?= $memcachedException ?></div>
        <?php } ?>
    </div>
</div>

<?php
phpinfo();
?>