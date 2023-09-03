<?php

$USER = "userWifi";
$PASSWORD = "passWifi";

$HOSTS = [
	'sw_wifi' => [ 	'ip' => "10.108.135.252",
					'oidState' => ['1.3.6.1.2.1.2.2.1.7'],	  // AdminStatus
					'valueOn' => "1",
					'portOffset' => 0],
];

$NODES = [

	'Point d\'accès Ubiquiti' => [
		'AP1' => ['parent' => 'sw_wifi', 'port' => 1],
		'AP2' => ['parent' => 'sw_wifi', 'port' => 2],
		'AP3' => ['parent' => 'sw_wifi', 'port' => 3],
		'AP4' => ['parent' => 'sw_wifi', 'port' => 4],
		'AP5' => ['parent' => 'sw_wifi', 'port' => 5],
		'AP6' => ['parent' => 'sw_wifi', 'port' => 6],
		'AP7' => ['parent' => 'sw_wifi', 'port' => 7],
		'AP8' => ['parent' => 'sw_wifi', 'port' => 8],			
	],
	'Ponts Ubiquiti (1-4)' => [
		'BR1A' => ['parent' => 'sw_wifi', 'port' => 9],
		'BR1B' => ['parent' => 'sw_wifi', 'port' => 10],
		'BR2A' => ['parent' => 'sw_wifi', 'port' => 11],
		'BR2B' => ['parent' => 'sw_wifi', 'port' => 12],
		'BR3A' => ['parent' => 'sw_wifi', 'port' => 13],
		'BR3B' => ['parent' => 'sw_wifi', 'port' => 14],
		'BR4A' => ['parent' => 'sw_wifi', 'port' => 15],
		'BR4B' => ['parent' => 'sw_wifi', 'port' => 16],	
	],
];
?>