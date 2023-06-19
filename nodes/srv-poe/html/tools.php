<?php
include ("config.php");

# Retourne le groupe d'appartenant du point d'accès en fonction de son nom
# null si non trouvé
function getGroupe($id) {
	$trouve = null;
	$i=0;

	global $NODES;	
	foreach ($NODES as $key => $value) {
		foreach ($value as $apName => $params) {
			if ($apName == $id) {
				$trouve = $key;
				break;				
			}
		}
		if ($trouve != null) {
			break;
		}		
		$i++;
	}
	return $trouve;
}


// Retourne la liste de tous les noeuds attachés à un switch
function getChilds($parent){
	
	$NODES = $GLOBALS["NODES"];
	$childs = [];

	foreach ($NODES as $key => $value) {
		foreach ($value as $apName => $params) {
			if($NODES[$key][$apName]['parent'] == $parent){
				array_push($childs, $apName);
			}
		}	
	}
	
	return $childs;
}

// Retourne le nom d'une noeud à partir du port de connexion
function getNodeName($parent, $port){
		
	$nodeName = null;
	$NODES = $GLOBALS["NODES"];

	foreach ($NODES as $key => $value) {
		foreach ($value as $apName => $params) {
			
			if ( ($NODES[$key][$apName]['parent'] == $parent) && ($NODES[$key][$apName]['port'] == $port)) {				
				$nodeName = $apName;
				break;
			}
		}	
		if ($nodeName != null) {
			break;
		}
	}
	
	return $nodeName;
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

