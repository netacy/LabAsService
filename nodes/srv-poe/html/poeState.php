<?php
require_once ("configMonSW.php");

$re = '/.\.+([0-9]+) =.+([0-9])$/m';
$node="null";
$state=[];

foreach ( $HOSTS as $hostID => $val) {
	
	$host = $HOSTS[$hostID]['ip'];
	$oid = $HOSTS[$hostID]['oidState'][0];

	$cmd='snmpwalk -v 3 -u '.$USER.' -l authNoPriv -a md5 -A '.$PASSWORD.' '.$host.' '.$oid;
	
	if (isHostAlive($host)) {
		exec($cmd,$res);
		
		for ($i=0;$i < sizeof($res); $i++) {
			preg_match_all($re, $res[$i], $matches, PREG_SET_ORDER, 0);	
			$id = $matches[0][1];					
			$value = $matches[0][2];
			
			if ($value == $HOSTS[$hostID]['valueOn']) {
				$value = 1;
			}
			else {
				$value = 0;
			}									
			$tmp = getNodeName($hostID, $id - $HOSTS[$hostID]['portOffset'] );
			if ($tmp != "" ) {			
				$node = $tmp;
				$state[$node]=$value;		
			}
		}
	}
}

unset($state["null"]);
echo json_encode($state);

?>

