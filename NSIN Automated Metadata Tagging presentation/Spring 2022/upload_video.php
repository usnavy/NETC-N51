<html>
<body>

<?php

ini_set('upload_max_filesize', '100000M');
ini_set('post_max_size', '1000000M');
ini_set('max_input_time', 300000000);
ini_set('max_execution_time', 300000000);

echo '<br>';
echo '<a href="https://nsinfaumeta.hpc.fau.edu/#about">Back to Main Page</a>';
echo '<br>';

                ini_set('display_errors', 1);
                ini_set('display_startup_errors', 1);
                error_reporting(E_ALL);


	/*Get the name of the uploaded file*/
	$filename = $_FILES['file']['name'];

	/*Choose were to save the file*/
	$location = "files/".$filename;

	/*Save the file to the local filesystem*/
	if(move_uploaded_file($_FILES['file']['tmp_name'], $location))
	{
    		echo 'File uploaded successfully';
	}else{
		echo '<b>Error uploading file.</b>';
		/*Print any errors*/
	}
//Now process the file by calling the python sript
echo '<br>Filename to process: ';	
echo $filename;
echo '<br>';
$exec_cmd = 'python3 files/transcript.py ' . $filename;
echo 'Command to execute:';
echo $exec_cmd;
echo '<br>';
$command = escapeshellcmd($exec_cmd);
$output = shell_exec($command);
echo $output;

echo '<br>';	
echo '<a href="https://nsinfaumeta.hpc.fau.edu/#portfolio">Back to Main Page</a>';
?>
</body>
</html>
