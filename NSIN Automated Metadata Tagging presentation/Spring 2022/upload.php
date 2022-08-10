<html>
<body>

<?php

echo '<br>';
echo '<a href="https://nsinfaumeta.hpc.fau.edu/#portfolio">Back to Main Page</a>';
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
echo '<h3>Processing PDF to TEXT</h3>';	
echo '<br>Filename to process: ';	
echo $filename;
echo '<br>';
$exec_cmd = 'python3 py/read_pdf_pypdf2_arg_cp2.py ' . $filename;
echo 'Command to execute:';
echo $exec_cmd;
echo '<br>';
$command = escapeshellcmd($exec_cmd);
$output = shell_exec($command);
echo $output;

echo '<h3>Processing PDF OCR</h3>';
$exec_cmd = 'python3 py/ocr_process.py ' . $filename;
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
