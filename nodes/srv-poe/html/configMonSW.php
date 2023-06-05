<?php


$NODES = [
	'ap1' => ['parent' => 'sw_wifi', 'port' => 2],
	'ap2' => ['parent' => 'sw_wifi', 'port' => 4],
	'ap3' => ['parent' => 'sw_wifi', 'port' => 6],
	'ap4' => ['parent' => 'sw_wifi', 'port' => 8],
	'ap5' => ['parent' => 'sw_wifi', 'port' => 10],
	'ap6' => ['parent' => 'sw_wifi', 'port' => 12],
	'ap7' => ['parent' => 'sw_wifi', 'port' => 14],
	'ap8' => ['parent' => 'sw_wifi', 'port' => 16],	
];

// Il est possible de piloter plusieurs switch et complétant le tableau suivant 
$HOSTS = [
	'sw_wifi' => [ 'ip' => "_IP_",
					'oidState' => ['1.3.6.1.2.1.105.1.1.1.3.2'], 
					'valueOn' => "1",
					'portOffset' => 2],
];

$USER = "_USER_";
$PASSWORD = "_PASSWORD_";

$ALLOWED_NET="_NETALLOWED_";

// Retourne la liste de tous les noeuds attachés à un switch
function getChilds($parent){
	
	$NODES = $GLOBALS["NODES"];
	$childs = [];
	foreach(array_keys($NODES) as $key){
		if ( $NODES[$key]['parent'] == $parent ) {
			array_push($childs, $key);
		}	
	}
	
	return $childs;
}

// Retourne le nom d'une noeud à partir du port d'interconnexion
function getNodeName($parent, $port){
		
	$node = "";
	$NODES = $GLOBALS["NODES"];

	$nodesID = getChilds($parent);
	$i = 0;
	foreach ( $nodesID as $id ) {
		$i++;
		if  ( $NODES[$id]['port'] == $port) {
			$node = $id;
			break;
		}
	}
	
	return $node;
}

function isHostAlive($host){
	$cmd = 'ping -c 1 -W 1 '.$host;
	$txt="";
	$ret=-1;
	exec($cmd,$txt,$ret);
	
	if ($ret == 0) {
		$myReturn = true;
	}
	else{
		$myReturn = false;
	}
	return $myReturn;
}


?>

