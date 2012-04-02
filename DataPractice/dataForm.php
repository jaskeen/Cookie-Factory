
<?php
extract($_GET);
extract($_POST);

//check to see if $fColor exists
if ($sessionID) {
    //process the variables
    print $class." is so awesome";
} else {
	print "fail";
}

?>
