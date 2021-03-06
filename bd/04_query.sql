/************************************************************************************/
/*  3.f.i.1 - 3810 - alta d'ubicació d'una màquina   */
/************************************************************************************/

/* canviar les variables */

INSERT INTO ubicacio
VALUES (NULL,"$empUbic","$dirUbic","$pobUbic","$cpUbic","$provUbic","$latUbic","$longUbic","$altUbic",
"$contactoUbic","$emailUbic","$telUbic","$mobilUbic",NOW(),NULL,NULL);

/*

select * from ubicacio;

INSERT INTO ubicacio
VALUES (NULL,"a1a2a3","dir","pob","cp","prov","25","50","8","maria","maria@gmail.com",
"987878987","654789098",NOW(),NULL,NULL);

select * from ubicacio;

*/

/************************************************************************************/
/*  3.f.i.2 - 3820 - baixa d'ubicació d'una màquina   */
/************************************************************************************/


UPDATE ubicacio SET _16_datBaixaUbic = NOW()

WHERE 

/* canviar les variables */

		_01_pk_idUbic = "$idUbic" AND
		_16_datBaixaUbic IS NULL;


/*
UPDATE ubicacio SET _16_datBaixaUbic = NOW()

WHERE 
		_01_pk_idUbic = "1" AND
		_16_datBaixaUbic IS NULL;


select * from ubicacio;

UPDATE ubicacio SET _16_datBaixaUbic = NULL

WHERE 
		_01_pk_idUbic = "6" AND
		_16_datBaixaUbic IS NOT NULL;
*/


/************************************************************************************/
/*  3.f.i.3 - 3830 - modificació d'ubicació d'una màquina   */
/************************************************************************************/

/* canviar les variables */


UPDATE ubicacio SET 
							_02_empUbic     = "$emp",
							_03_dirUbic     = "$dir",
							_04_pobUbic     = "$pob",
							_05_cpUbic      = "$cp",
							_06_provUbic    = "$prov",
							_07_latUbic     = "$latitut",
							_08_longUbic    = "&longitud",
							_09_altUbic     = "&altitud",
							_10_contUbic    = "$personaContacte",
							_11_emailUbic   = "$emailContacte",
							_12_telUbic     = "$telContacte",
							_13_mobUbic     = "$mobilContacte",
							_14_datAltaUbic = "$dataAltaUbic",
							_15_datModUbic  = NOW(),
							_16_datBaixaUbic= "$dataBaixaUbic"

WHERE 
		_01_pk_idUbic = "$idUbic";
		

/*

select * from ubicacio;

UPDATE ubicacio SET 
							_02_empUbic     = "aabbcc",
							_03_dirUbic     = "dir11",
							_04_pobUbic     = "pob11",
							_05_cpUbic      = "cp11",
							_06_provUbic    = "prov11",
							_07_latUbic     = "11",
							_08_longUbic    = "12",
							_09_altUbic     = "13",
							_10_contUbic    = "josep",
							_11_emailUbic   = "josep@gmail.com",
							_12_telUbic     = "932134323",
							_13_mobUbic     = "612345678",
							_14_datAltaUbic = "2014-06-23 10:10:10",
							_15_datModUbic  = NOW(),
							_16_datBaixaUbic= NULL

WHERE 
		_01_pk_idUbic = "6";

select * from ubicacio;

*/
		
/************************************************************************************/
/*  3.f.i.4 - 3840 - Llistat d'ubicacions (provincia, població, cp)   */
/************************************************************************************/

SELECT _06_provUbic AS provincia,_04_pobUbic AS poblacio,_05_cpUbic AS cPostal,
_01_pk_idUbic AS idUbic, _02_empUbic AS empUbic, _03_dirUbic AS dirUbic,
_07_latUbic AS latitut, _08_longUbic AS longitut, _09_altUbic AS altitut,
_10_contUbic AS contactUbic, _11_emailUbic AS emailContacte, _12_telUbic AS telefonContacte,
_13_mobUbic AS mobilContacte,
DATE_FORMAT(_14_datAltaUbic, "%d-%m-%Y %H:%i:%s")  AS datAltaUbic,
DATE_FORMAT(_16_datBaixaUbic, "%d-%m-%Y %H:%i:%s") AS datBaixaUbic


FROM ubicacio

GROUP BY provincia, poblacio, cPostal, idUbic
ORDER BY provincia, poblacio, cPostal;



/************************************************************************************/
/*  3.f.i.5 - 3850 - Llistat d'ubicacions (lat, long, alt)   */
/************************************************************************************/

SELECT _07_latUbic AS latitut, _08_longUbic AS longitut, _09_altUbic AS altitut,
_01_pk_idUbic AS idUbic, _02_empUbic AS empUbic, _03_dirUbic AS dirUbic,
_06_provUbic AS provincia,_05_cpUbic AS cPostal,_04_pobUbic AS poblacio,
_10_contUbic AS contactUbic, _11_emailUbic AS emailContacte, _12_telUbic AS telefonContacte,
_13_mobUbic AS mobilContacte,
DATE_FORMAT(_14_datAltaUbic, "%d-%m-%Y %H:%i:%s")  AS datAltaUbic,
DATE_FORMAT(_16_datBaixaUbic, "%d-%m-%Y %H:%i:%s") AS datBaixaUbic

FROM ubicacio

GROUP BY latitut, longitut, altitut, idUbic
ORDER BY latitut, longitut, altitut;


/************************************************************************************/
/*  3.f.i.6 - 3860 - Llistat d'empreses d'ubicacions amb les seves dades de contacte   */
/************************************************************************************/

SELECT _01_pk_idUbic AS idUbic, _02_empUbic AS empUbic, _03_dirUbic AS dirUbic,
_06_provUbic AS provincia,_05_cpUbic AS cPostal,_04_pobUbic AS poblacio,
_10_contUbic AS contactUbic, _11_emailUbic AS emailContacte, _12_telUbic AS telefonContacte,
_13_mobUbic AS mobilContacte,
DATE_FORMAT(_14_datAltaUbic, "%d-%m-%Y %H:%i:%s")  AS datAltaUbic,
DATE_FORMAT(_16_datBaixaUbic, "%d-%m-%Y %H:%i:%s") AS datBaixaUbic

FROM ubicacio

ORDER BY empUbic;


/************************************************************************************/
/*  3.f.i.7 - 3870 - Llistat d'empreses d'ubicacions per provincia, població, cp amb les seves dades de contacte   */
/************************************************************************************/

SELECT _06_provUbic AS provincia,_04_pobUbic AS poblacio,_05_cpUbic AS cPostal,
_01_pk_idUbic AS idUbic,_02_empUbic AS empUbic, _03_dirUbic AS dirUbic,
_10_contUbic AS contactUbic, _11_emailUbic AS emailContacte, _12_telUbic AS telefonContacte,
_13_mobUbic AS mobilContacte,
DATE_FORMAT(_14_datAltaUbic, "%d-%m-%Y %H:%i:%s")  AS datAltaUbic,
DATE_FORMAT(_16_datBaixaUbic, "%d-%m-%Y %H:%i:%s") AS datBaixaUbic

FROM ubicacio

ORDER BY provincia, poblacio, cPostal;


/************************************************************************************/
/*  3.f.ii.1 - 3880 - Alta de l'associació d'una màquina a una ubicació   */
/************************************************************************************/

/* canviar les variables */

INSERT INTO ubicacioTeMaquina
VALUES (NULL,"$idUbic","$idMaq",NOW(),NULL,NULL);

/*
INSERT INTO ubicacioTeMaquina
VALUES (NULL,"3","51",NOW(),NULL,NULL);
select * from ubicacioTeMaquina;
*/


/************************************************************************************/
/*  3.f.ii.1 - 3890 - Llistat de màquines per ubicació   */
/************************************************************************************/

SELECT _00_pk_idUTM_auto   AS recid,_06_provUbic AS provincia, _04_pobUbic AS poblacio, _05_cpUbic AS cPostal,
_01_pk_idUbicUTM AS idUbic, _02_empUbic AS empUbic, 
_02_pk_idMaqUTM AS idMaq,_02_macMaq AS macMaq, _03_propMaq AS propMaq,
SUM(_05_totCredMaq) AS totalCredits,
DATE_FORMAT(_03_datAltaUTM,  "%d-%m-%Y %H:%i:%s") AS datAltaUTM,
DATE_FORMAT(_04_datModUTM,   "%d-%m-%Y %H:%i:%s") AS datModUTM,
DATE_FORMAT(_05_datBaixaUTM, "%d-%m-%Y %H:%i:%s") AS datBaixaUTM,
DATE_FORMAT(_08_datBaixaMaq, "%d-%m-%Y %H:%i:%s") AS datBaixaMaq,
DATE_FORMAT(_16_datBaixaUbic,"%d-%m-%Y %H:%i:%s") AS datBaixaUbic

FROM ubicacio
INNER JOIN ubicacioTeMaquina ON _01_pk_idUbic   = _01_pk_idUbicUTM
INNER JOIN maquina           ON _02_pk_idMaqUTM = _01_pk_idMaq

GROUP BY provincia, poblacio, cPostal, idUbic, idMaq
ORDER BY provincia, poblacio, cPostal, idUbic, idMaq, totalCredits;


/************************************************************************************/
/*  3.f.ii.2 - 3900 - Bloquejar associació d'una màquina a una ubicació   */
/************************************************************************************/

UPDATE ubicacioTeMaquina SET _04_datModUTM   = NOW(),
									  _05_datBaixaUTM = NOW()
									  

WHERE 

/* canviar les variables */

	_00_pk_idUTM_auto = "$idUTM" AND
	_05_datBaixaUTM  IS NULL;
	

/*
UPDATE ubicacioTeMaquina SET _05_datBaixaUTM = NOW()

WHERE 

	_01_pk_idUbicUTM = "3" AND
	_02_pk_idMaqUTM  = "51" AND
	_05_datBaixaUTM  IS NULL;
select * from ubicacioTeMaquina;
UPDATE ubicacioTeMaquina SET _05_datBaixaUTM = NULL

WHERE 

	_01_pk_idUbicUTM = "3" AND
	_02_pk_idMaqUTM  = "51" AND
	_05_datBaixaUTM  IS NOT NULL;
select * from ubicacioTeMaquina;

*/

/************************************************************************************/
/*  3.f.ii.3 - 3905 - Desbloquejar associació d'una màquina a una ubicació   */
/************************************************************************************/

/* canviar les variables */

UPDATE ubicacioTeMaquina SET  _04_datModUTM   = NOW(),
										_05_datBaixaUTM = NULL

WHERE 

	_00_pk_idUTM_auto = "$idUTM" AND
	_05_datBaixaUTM  IS NOT NULL;	
 
/*
select * from ubicacioTeMaquina;
UPDATE ubicacioTeMaquina SET 
										_03_datAltaUTM  = "2014-06-15 10:10:10",
										_04_datModUTM   = NOW(),
										_05_datBaixaUTM = NULL

WHERE 

	_01_pk_idUbicUTM = "3"     AND
	_02_pk_idMaqUTM  = "51";
	
select * from ubicacioTeMaquina;
*/ 

/************************************************************************************/
/*  3.f.ii.4 - 3910 - Canvi d'ubicació d'una màquina */
/************************************************************************************/

UPDATE ubicacioTeMaquina SET _05_datBaixaUTM = NOW()
WHERE 

/* canviar les variables */

	_01_pk_idUbicUTM = "$idUbicVELL" AND
	_02_pk_idMaqUTM  = "$idMaq" AND
	_05_datBaixaUTM  IS NULL;


/* canviar les variables */	
	
INSERT INTO ubicacioTeMaquina VALUES (NULL,"$idUbicNOU","$idMaq",NOW(),NULL,NULL);


/*
select * from ubicacioTeMaquina;
UPDATE ubicacioTeMaquina SET _05_datBaixaUTM = NOW()

WHERE 
	_01_pk_idUbicUTM = "3" AND
	_02_pk_idMaqUTM  = "51" AND
	_05_datBaixaUTM  IS NULL;

select * from ubicacioTeMaquina;

START TRANSACTION;
set autocommit = 0;
SELECT * FROM ubicacioTeMaquina
WHERE 
	_01_pk_idUbicUTM = "2" AND
	_02_pk_idMaqUTM  = "51" AND
	_05_datBaixaUTM  IS NULL;
INSERT INTO ubicacioTeMaquina VALUES (NULL,"2","51",NOW(),NULL,NULL) 
COMMIT;

select * from ubicacioTeMaquina;
*/


/************************************************************************************/
/*  3.f.ii.5 - 3930 - Llistat de les màquines de cada ubicació (provincia, població, cp) */
/************************************************************************************/

SELECT _06_provUbic AS provincia, _04_pobUbic AS poblacio, _05_cpUbic AS cPostal,
_01_pk_idMaq AS idMaq, _02_macMaq AS macMaq, SUM(_05_totCredMaq) AS totalCredits

FROM ubicacio
INNER JOIN ubicacioTeMaquina ON _01_pk_idUbic   = _01_pk_idUbicUTM
INNER JOIN maquina           ON _02_pk_idMaqUTM = _01_pk_idMaq

WHERE 	
	_08_datBaixaMaq  IS NULL AND
	_05_datBaixaUTM  IS NULL AND	
	_16_datBaixaUbic IS NULL
	
GROUP BY provincia, poblacio, cPostal, _01_pk_idUbic, idMaq
ORDER BY provincia, poblacio, cPostal, _01_pk_idUbic, idMaq, totalCredits;


/************************************************************************************/
/*  3.f.ii.6 - 3940 - Llistat de màquines de cada ubicació (lat, long, alt)) */
/************************************************************************************/


SELECT _07_latUbic AS latitut, _08_longUbic AS longitut, _09_altUbic AS altitut,
_06_provUbic AS provincia, _04_pobUbic AS poblacio,
_01_pk_idMaq AS idMaq, _02_macMaq as macMaq, SUM(_05_totCredMaq) AS totalCredits

FROM ubicacio
INNER JOIN ubicacioTeMaquina ON _01_pk_idUbic   = _01_pk_idUbicUTM
INNER JOIN maquina           ON _02_pk_idMaqUTM = _01_pk_idMaq

WHERE 	
	_08_datBaixaMaq  IS NULL AND
	_05_datBaixaUTM  IS NULL AND	
	_16_datBaixaUbic IS NULL
	
GROUP BY latitut, longitut, altitut, _01_pk_idUbic, idMaq
ORDER BY latitut, longitut, altitut, _01_pk_idUbic, idMaq, totalCredits;



/************************************************************************************/
/*  3.f.ii.7 - 3950 - Llistat de màquines de cada empresa on estan ubicades les màquines */
/************************************************************************************/


SELECT _01_pk_idUbic AS idUbic,_02_empUbic AS empUbic, _03_dirUbic AS dirUbic,
_06_provUbic AS provincia,_05_cpUbic AS cPostal,_04_pobUbic AS poblacio,
_10_contUbic AS contactUbic, _11_emailUbic AS emailContacte, _12_telUbic AS telefonContacte,
_13_mobUbic AS mobilContacte,
_01_pk_idMaq AS idMaq, _02_macMaq AS macMaq, SUM(_05_totCredMaq) AS totalCredits

FROM ubicacio
INNER JOIN ubicacioTeMaquina ON _01_pk_idUbic   = _01_pk_idUbicUTM
INNER JOIN maquina           ON _02_pk_idMaqUTM = _01_pk_idMaq

WHERE 	
	_08_datBaixaMaq  IS NULL AND
	_05_datBaixaUTM  IS NULL AND	
	_16_datBaixaUbic IS NULL
	
GROUP BY empUbic, _01_pk_idUbic, idMaq
ORDER BY empUbic, _01_pk_idUbic, idMaq, totalCredits;

