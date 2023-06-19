<?php
require ("tools.php");
?>

<!DOCTYPE html>
<html>
  <head>
  <title>Switch WiFi</title>
  
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta name="description" content="index.html">
  <meta name="keywords" content="html5,skeleton,index,homepage,jquery,bootstrap">
  <meta name="author" content="Julien HOARAU">
  
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
   <a class="navbar-brand" href="/">Switch WiFi</a>
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
<table border="0" width="80%">

<tr align="center">
	<?php

	$i=0;
	foreach ($NODES as $groupeAP => $item) {
		echo '<td> <h4>'.$groupeAP.'<input type="checkbox" id="all-'.$i.'" onchange="setAll(id);"  checked data-toggle="toggle" data-size="xs"></h4></td>';	
		$i++;
	}
	?>	
</tr>


<tr align="center">
	<?php 
	
	$i=0;
	foreach ($NODES as $groupeAP => $item) {
		echo '<td><table border="0">';
		foreach ($item as $apName => $values) {						
			echo '<tr><td>'.$apName.'</td><td><input type="checkbox" id="'.$apName.'" name="all-'.$i.'" onchange="setOne(id);" checked data-toggle="toggle" data-size="xs"></td></tr>';			
		}
		echo '</table></td>';
		$i++;
	}


	?>		
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
		myAction = "on"
	}
	else{
		myAction = 'off'
	}
	
	$.ajax({
	  type: "GET",
	  url: "api.php?action=setState&id="+id+"&action2="+myAction,
	  success: function(data) {
			console.log(data);
	  },
	});	
	
}	

function update(){
	$.ajax({
	  type: "GET",
	  url: "api.php?action=getState",
	  success: function(data) {
	
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
				}				
				elem.onchange = old_onChange
			}	
		});	
		
	
	  },
	});	
}
window.setInterval(update,5000);

</script>
 

</body>
</html>