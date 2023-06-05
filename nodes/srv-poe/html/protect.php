<?php
require_once ("configMonSW.php");


$re = '/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\.[0-9]{1,3}/m';
$ip = $_SERVER['REMOTE_ADDR'];

preg_match_all($re, $ip, $matches, PREG_SET_ORDER, 0);

$net_src=$matches[0][1];


echo "
<div style=\"text-align:center;\">
\n<b>Vos actions seront enregistrées</b> avec votre adresse IP : <span style=\"background-color: yellow;\">".$_SERVER['REMOTE_ADDR']." (".date("d-m-Y H:i:s").") </span>
</div>
";

?>