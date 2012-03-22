
<html>
<head>
<title>Form Fun!</title>
</head>

<body>
<b>Have you ever wondered what your favorite color and number say about you? Here's your chance!</b> 
<br>
<?php
extract($_GET);
extract($_POST);

//check to see if $fColor exists
if ($fColor) {
    //process the variables
    print "your color is: ".$fColor;
} else {
	print "you didn't pass in a variable";
}



/*
if ($fColor == "Green") {
	echo "Here you have it... <br> Hey! $fColor is my favorite color too... the color of Basil, the 'spice of the gods'!";
} else if ($fColor == "Yellow") { echo "Here you have it...<br> I won't hold it against you. $fColor is a happy color, but it's
	more of an accent color, in my opinion."; }
else if ($fColor != '') {echo "Here you have it...<br> You're a good person. Does $fColor match the color of your eyes?";}
else { ?>
<form action="<?php $_SERVER['PHP_SELF'] ?>" method="GET">
	<p>Favorite Color: <input type="text" size="50" name="fColor" value='"<?php $fColor?>"' />
  <br>
    Favorite Number: <input type="text" name="fNumber" />
  <br>
    <textarea cols="100" rows="40" name="text">Please type your reasoning here</textarea>
  <br>
    <input type="submit" value="Send it!" />
</form>
<?php } ?>
*/
?>
</body>
</html>
