<?php

	if (!isset($_REQUEST['cmd']) ) die('<h1>No es una consulta correcte !</h1>');

	$link = mysql_connect('localhost', 'root', '');

	if (!$link)	die('Not connected : ' . mysql_error());

	$db_selected = mysql_select_db('u555588791_pinba', $link);

	if (!$db_selected) {
	    die ('No es possible utilitzar bd pinball: ' . mysql_error());
	}

	if (isset($_REQUEST['cmd']))    $action = $_REQUEST['cmd'];
	if (isset($_REQUEST['param']))  $table  = $_REQUEST['param'];
	if (isset($_REQUEST['recid']))	$id 	= $_REQUEST['recid'];


	$pid      = isset($_REQUEST['pid'])       ? (int) $_REQUEST['pid'] : 0;


	$kName  = isset($_REQUEST['keyname']) ? $_REQUEST['keyname'] : 'id';
	$data   = array();
	$qry    = "";

	switch ($action)
	{
		case 'ld' :
			$qry  	= "SELECT * FROM $table";
			$result = Sql_Exec($qry);

			while ($row = mysql_fetch_object($result)) {
			       $data[] = $row->_01_pk_idJoc; //. "-". $row->_02_nomJoc;
			}
			$data = array("items"=>$data);
			break;

		case 'get-record' :
			$qry  	= "SELECT * FROM $table WHERE $kName=$id";
			$result = Sql_Exec($qry);
			$data 	= mysql_fetch_assoc($result);
			break;

		case 'get-records' :
			$qry = "SELECT * FROM $table";
			$result = Sql_Exec($qry);

			while ($row = mysql_fetch_assoc($result)) {
				   $row["recid"] = current($row);	
			       $data[] = $row;
			}
			// Preparar array per a retornar al grid tots els registres
			$data = array( 'total' => mysql_num_rows($result), 'page' => 0, 'records' => $data );
			$data['cmd'] = "get-records";
			break;

		case 'delete' :
			$qry  = "DELETE FROM $table WHERE $kName=$id";
	    	$sql  = Sql_Exec($qry);
			$data = array( 'cmd' => 'delete', 'success' => (mysql_affected_rows() != 0) );
			break;

		case 'save-record' :

			$record = (object)$_REQUEST['record'];

			// if($_REQUEST['pid']) :
			//  	$data = CustomQuery($_REQUEST['pid'], $id, $record);

			if($pid) :
			 	$data = customQuery($pid, $id, $_REQUEST['record']);			 
			else :
				// if remote
				// $record = json_decode($_REQUEST['record']);
				// else

				// $record = (object)$_REQUEST['record'];

				if ($id != 0) :
					foreach( $record as $key => $value ) {
						if ($key != 'recid') $qry .= $key .'="'. $value .'",';
					}
		    		// Eliminar ultima comma ","
		    		$qry = substr( $qry, 0, -1 ); 
					$qry = "UPDATE $table SET ". $qry ." WHERE $kName=$id";

				else :
					$sKey=""; $sVal="";
					foreach( $record as $key => $value ) {
						if ($key  != 'recid') {
							$sKey .= $key .",";
							$sVal .= "'". $value ."',";
						}
					}
					$sKey = substr( $sKey, 0, -1 );  
	        		$sVal = substr( $sVal, 0, -1 );  
					$qry  = "INSERT INTO $table (". $sKey . ") VALUES (". $sVal . ")";
				endif;

				$sql = Sql_Exec($qry);
				$data['recid'] = ($id != 0) ? $id : mysql_insert_id();
				$data['rows']  = mysql_affected_rows();
			endif;
			break;
	}

	echo json_encode( $data );


	function Sql_Exec($query) {
		
		$result = mysql_query($query);

		if (!$result) {
		    die('Consulta no valida: ' . mysql_error());
		}

		return $result;
	}

	function customQuery($pid, $id, $record)
	{
		switch($pid)
			{
			case '3230':
				$query    = 'INSERT INTO joc 
								VALUES (NULL,"' .
										$record['_02_nomJoc']  . '","' .
										$record['_03_descJoc'] . '","' .
										$record['_04_imgJoc']  . '","
										0,NOW(),NULL,NULL);';			
				$sql = Sql_Exec($query);
				// $response = dbExec($query,0);
				// echo json_encode(controlErrorQuery($response));
				$data['recid'] = mysql_insert_id();
				$data['rows']  = mysql_affected_rows()+10;				
				break;
			default:
				$data = "";
				break;
			}
		return ($data);
	}

 ?>