<?php
require_once ("tools.php");


$action = $_GET['action'];

switch ($action) {
    case 'getState':
        
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
        



        break;
    case 'setState':
        
        // ---------------------------------------------------------------------------------------
        // Récupère le nom de l'AP, et impose l'état du port POE en fonction de ce qui est demandé
        // ---------------------------------------------------------------------------------------
        
        $id = $_GET['id'];

        $grp=getGroupe($id);

        if (!$grp){
            // L'action est demandée sur un équiepement qui n'existe pas.
            exit();
        }


        // Nom du switch
        $sw_name = $NODES[$grp][$id]['parent'];

        // Port du switch switch
        $port    = $NODES[$grp][$id]['port'];

        // Offset à appliquer sur le num de port
        $offset  = $HOSTS[$sw_name]['portOffset'];
        $suffixe = $port + $offset;

        // @IP du switch
        $host    = $HOSTS[$sw_name]['ip'];

        if ($_GET['action2'] == "on"){
            // POE -> on 
            $action = 1; 
        }
        else{
            // POE -> off 
            $action = 2;
        }

        foreach ($HOSTS[$sw_name]['oidState'] as $oid) {	
            $cmd='snmpset -v 3 -u '.$USER.' -l authNoPriv -a md5 -A '.$PASSWORD.' '.$host.' '.$oid.'.'.$suffixe.' i '.$action;
            exec($cmd,$res);
        }
        
        break;
    
}

?>
