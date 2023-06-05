<!DOCTYPE html>
<html>
  <head>
  <title>Switch WiFi C274</title>
  
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta name="description" content="HTML5 skeleton index.html">
  <meta name="keywords" content="html5,skeleton,index,homepage,jquery,bootstrap">
  <meta name="author" content="Arul John">
  
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" media="screen" rel="stylesheet">
  <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  
  <link href="https://cdn.jsdelivr.net/gh/gitbrent/bootstrap4-toggle@3.6.1/css/bootstrap4-toggle.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/gh/gitbrent/bootstrap4-toggle@3.6.1/js/bootstrap4-toggle.min.js"></script>
 

  </head>
<body>
<header class="navbar navbar-default">
  <nav>
   <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
    <span class="sr-only">Toggle navigation</span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
    <span class="icon-bar"></span>
   </button>
   <a class="navbar-brand" href="/">Switch WiFi C274</a>
  </nav>
  <div class="container">
    <div class="navbar-collapse collapse">
      <ul class="nav navbar-nav navbar-left">
        <li><a href="/index.php"><span class="fa fa-help-o"></span> Power</a></li>
	</ul>
    </div>
  </div>
</header>

<main role="main">

<?php
include ("protect.php");
?>
<table border="0" width="80%">

<tr align="center">
	<td> <h4>Points d'accès Ubiquiti <input type="checkbox" id="all-ap" onchange="setAll(id);"  checked data-toggle="toggle" data-size="xs"></h4></td>
	<td> <h4>Ponts Ubiquiti (1-4)    <input type="checkbox" id="all-br" onchange="setAll(id);" checked data-toggle="toggle" data-size="xs"></h4>  </td>
	<td> <h4>Ponts Ubiquiti (5-8)     <input type="checkbox" id="all-br2" onchange="setAll(id);" checked data-toggle="toggle" data-size="xs"></h4>  </td>
	<td> <h4>Bornes légères Cisco    <input type="checkbox" id="all-lap" onchange="setAll(id);" checked data-toggle="toggle" data-size="xs"></h4></td>
	<td> <h4>Bornes monitor          <input type="checkbox" id="all-mon" onchange="setAll(id);" checked data-toggle="toggle" data-size="xs"></h4></td>
</tr>

  
<tr align="center">
	<td>
		<table border="0">
		<tr><td>AP1</td><td><input type="checkbox" id="ap1" name="all-ap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>AP2</td><td><input type="checkbox" id="ap2" name="all-ap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>AP3</td><td><input type="checkbox" id="ap3" name="all-ap" id="ap3" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>AP4</td><td><input type="checkbox" id="ap4" name="all-ap" id="ap4" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>AP5</td><td><input type="checkbox" id="ap5" name="all-ap" id="ap5" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>AP6</td><td><input type="checkbox" id="ap6" name="all-ap" id="ap6" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>AP7</td><td><input type="checkbox" id="ap7" name="all-ap" id="ap7" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>AP8</td><td><input type="checkbox" id="ap8" name="all-ap" id="ap8" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>AP9</td><td><input type="checkbox" id="ap9" name="all-ap" id="ap9" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		</table>
	</td>

	<td>
		<table border="0">
		<tr><td>BR1A</td><td><input type="checkbox" id="br1a" name="all-br" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR1B</td><td><input type="checkbox" id="br1b" name="all-br" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR2A</td><td><input type="checkbox" id="br2a" name="all-br" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR2B</td><td><input type="checkbox" id="br2b" name="all-br" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR3A</td><td><input type="checkbox" id="br3a" name="all-br" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR3B</td><td><input type="checkbox" id="br3b" name="all-br" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR4A</td><td><input type="checkbox" id="br4a" name="all-br" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR4B</td><td><input type="checkbox" id="br4b" name="all-br" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		</table>
	</td>
	
	<td>
		<table border="0">
		<tr><td>BR5A</td><td><input type="checkbox" id="br5a" name="all-br2" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR5B</td><td><input type="checkbox" id="br5b" name="all-br2" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR6A</td><td><input type="checkbox" id="br6a" name="all-br2" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR6B</td><td><input type="checkbox" id="br6b" name="all-br2" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR7A</td><td><input type="checkbox" id="br7a" name="all-br2" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR7B</td><td><input type="checkbox" id="br7b" name="all-br2" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR8A</td><td><input type="checkbox" id="br8a" name="all-br2" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>BR8B</td><td><input type="checkbox" id="br8b" name="all-br2" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		</table>
	</td>
	
	<td>
		<table border="0">
		<tr><td>LAP1</td><td><input type="checkbox" id="lap1" name="all-lap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>LAP2</td><td><input type="checkbox" id="lap2" name="all-lap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>LAP3</td><td><input type="checkbox" id="lap3" name="all-lap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>LAP4</td><td><input type="checkbox" id="lap4" name="all-lap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>LAP5</td><td><input type="checkbox" id="lap5" name="all-lap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>LAP6</td><td><input type="checkbox" id="lap6" name="all-lap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>LAP7</td><td><input type="checkbox" id="lap7" name="all-lap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>LAP8</td><td><input type="checkbox" id="lap8" name="all-lap" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		</table>
	</td>	
	<td>
		<table border="0">
		<tr><td>MON1</td><td><input type="checkbox" id="mon1" name="all-mon" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>MON2</td><td><input type="checkbox" id="mon2" name="all-mon" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>MON3</td><td><input type="checkbox" id="mon3" name="all-mon" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>MON4</td><td><input type="checkbox" id="mon4" name="all-mon" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		<tr><td>MON5</td><td><input type="checkbox" id="mon5" name="all-mon" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>
		</table>
	</td>
</tr>
</table> 

<script>


function setAll(id)
{	
	var toggles = document.getElementsByName(id);
	if (document.getElementById(id).checked) {
		action="on"
	}
	else {
		action="off"
	}	
	toggles.forEach((element, index)  => {
		bs_name = "#"+element.id
		$(bs_name).bootstrapToggle(action)
	});
}


			
function setOne(id)
{
	if (document.getElementById(id).checked) {
		action = "on"
	}
	else{
		action = 'off'
	}
	
	$.ajax({
	  type: "GET",
	  url: "poeSetState.php?id="+id+"&action="+action,
	  success: function(data) {
			console.log(data);
	  },
	});	
	
}	

function update(){
	$.ajax({
	  type: "GET",
	  url: "poeState.php",
	  success: function(data) {

		allAP=0;
		allBR=0;
		allBR2=0;
		allLAP=0;
		allMON=0;
		
		JSON.parse(data, (key, value) => {
		
			if (typeof value === 'number') {				
				elem=document.getElementById(key)
				old_onChange = elem.onchange
				elem.onchange = null
				bs_name="#"+elem.id

				if (value == 0) {
						$(bs_name).bootstrapToggle('off')
				}
				else {
						$(bs_name).bootstrapToggle('on')
						switch(elem.name){
							case 'all-ap':
								allAP=1;
							break;
							case 'all-br':
								allBR=1;
							case 'all-br2':
								allBR2=1;
							break;
							case 'all-lap':
								allLAP=1;
							break;
							case 'all-mon':
								allMON=1;
							break;
						}
				}				
				elem.onchange = old_onChange
			}	
		});	
		globalSW='{"all-ap":'+allAP+',"all-br":'+allBR+',"all-lap":'+allLAP+',"all-mon":'+allMON+',"all-br2":'+allBR2+'}'
			
		JSON.parse(globalSW, (key, value) => {	
			if (typeof value === 'number') {				
				elem=document.getElementById(key)
				old_onChange = elem.onchange
				elem.onchange = null
				bs_name="#"+elem.id

				if (value != 0) {
						$(bs_name).bootstrapToggle('on')
				}
				else {
						$(bs_name).bootstrapToggle('off')
				}				
				elem.onchange = old_onChange
			}	
		});
	
	  },
	});	
}
window.setInterval(update,2000);

</script>
 

</body>
</html>