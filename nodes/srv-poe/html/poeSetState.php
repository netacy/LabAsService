<?php

require_once ("configMonSW.php");
 
$id = $_GET['id'];

$sw_name = $NODES[$id]['parent'];
$port    = $NODES[$id]['port'];
$offset  = $HOSTS[$sw_name]['portOffset'];
$host    = $HOSTS[$sw_name]['ip'];

$suffixe = $port + $offset;


if ($_GET['action'] == "on"){
	$action = 1;
}
else{
	$action = 2;
}

foreach ($HOSTS[$sw_name]['oidState'] as $oid) {	
	$cmd='snmpset -v 3 -u '.$USER.' -l authNoPriv -a md5 -A '.$PASSWORD.' '.$host.' '.$oid.'.'.$suffixe.' i '.$action;
	exec($cmd,$res);
}






?>

