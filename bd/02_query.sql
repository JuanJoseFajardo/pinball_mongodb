/***********************************************************************************************/
/* 3.a.1 - consulta perfil administrador / usuari */
/***********************************************************************************************/


SELECT _01_pk_idUsuari AS idUsr,_02_nomUsuari AS nomUsr,_03_cognomUsuari AS cogUsr,
_04_loginUsuari AS loginUsr, _05_pwdUsuari AS passwordUsr, _06_emailUsuari AS emailUsr,
_07_fotoUsuari AS fotoUsr, _02_faceAdm AS facebookAdm, _03_twitterAdm AS twitterAdm
FROM usuari
LEFT JOIN admin ON _01_pk_idUsuari = _01_pk_idAdm
WHERE
	_10_datBaixaUsuari IS NULL AND
	_06_datBaixaAdm    IS NULL AND
	_04_loginUsuari = "admin";


/***********************************************************************************************/
/* 3.a.2 - 3000 - modificacio perfil administrador */
/***********************************************************************************************/

/* canviar variables amb $ per valors */

UPDATE usuari SET _02_nomUsuari     = "$nom",
						_03_cognomUsuari  = "$cognom",
						_06_emailUsuari   = "$email",
						_07_fotoUsuari    = "$nomFoto",
						_08_datAltaUsuari = "$dataAltaUsuari",						
						_09_datModUsuari  = NOW()
WHERE
		_10_datBaixaUsuari IS NULL AND
		_04_loginUsuari = "admin";


/* canviar variables amb $ per valors */


UPDATE admin SET   _02_faceAdm    = "$facebook",
						 _03_twitterAdm = "$twitter",
						 _04_datAltaAdm = "$dataAltaAdm",	
						 _05_datModAdm  = NOW()
WHERE 
		_06_datBaixaAdm IS NULL AND
		(_01_pk_idAdm IN ( SELECT _01_pk_idUsuari AS _01_pk_idAdm FROM usuari
		WHERE _04_loginUsuari = "admin"));
		

/* ejemplo

START TRANSACTION;
UPDATE usuari SET _02_nomUsuari    = "admin",
						_03_cognomUsuari = "admin",
						_06_emailUsuari  = "admin@gmail.com",
						_07_fotoUsuari   = 'admin.jpg',
						_09_datModUsuari = NOW()
WHERE
		_10_datBaixaUsuari IS NULL AND
		_04_loginUsuari = "admin";


UPDATE admin SET   _02_faceAdm    = "adminfacebook",
						 _03_twitterAdm = "@adminpinball",
						 _05_datModAdm  = NOW()
WHERE 
		_06_datBaixaAdm IS NULL AND
		(_01_pk_idAdm IN ( SELECT _01_pk_idUsuari AS _01_pk_idAdm FROM usuari
		WHERE _04_loginUsuari = "admin"));
		
select * from usuari;
select * from admin;
COMMIT;

*/

/************************************************************************************/
/* 3.b.1 - 3110 - llistar partides per màquina  */
/************************************************************************************/


SELECT  _00_pk_idPart_auto AS recid, _01_pk_idMaqPart AS idMaq, _01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn,
_02_pk_idJocPart AS idJoc, _02_nomJoc AS nomJoc,
DATE_FORMAT(_04_pk_idDatHoraPart, "%d-%m-%Y %H:%i:%s") AS datHoraPartida,
 _00_pk_idPart_auto AS idPart, 
DATE_FORMAT(_05_datIniTorn, "%d-%m-%Y") AS datIniTorn,
DATE_FORMAT(_06_datFinTorn, "%d-%m-%Y") AS datFinTorn, 
DATE_FORMAT(_06_datBaixaPart, "%d-%m-%Y %H:%i:%s") AS datBaixaPart

FROM

partida AS PP
LEFT JOIN torneigTePartida ON (_02_pk_idMaqTTP = _01_pk_idMaqPart AND
							          _03_pk_idJocTTP = _02_pk_idJocPart AND
						         	 _04_pk_idJugTTP = _03_pk_idJugPart )
INNER JOIN torneig 			ON ( _01_pk_idTornTTP = _01_pk_idTorn AND
										  _03_pk_idJocTTP  = _02_pk_idJocTorn)
INNER JOIN joc 				ON (_02_pk_idJocTorn = _01_pk_idJoc),

(SELECT _01_pk_idUsuari, _02_nomUsuari AS nomJug,_04_loginUsuari AS loginJug FROM usuari) AS BB

WHERE _03_pk_idJugPart = BB._01_pk_idUsuari

GROUP BY idMaq, idPart
ORDER BY idMaq, idJoc, datHoraPartida


/************************************************************************************/
/* 3.b.2 - 3120 - llistar partides per jugador  */
/************************************************************************************/


SELECT _00_pk_idPart_auto AS recid, _03_pk_idJugPart AS idUser,BB.loginJug AS loginUser, BB.nomJug AS nomUser,
_01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn,
_02_pk_idJocPart AS idJoc, _02_nomJoc AS nomJoc,_01_pk_idMaqPart AS idMaq,
DATE_FORMAT(_04_pk_idDatHoraPart, "%d-%m-%Y %H:%i:%s") AS datHoraPartida,
 _00_pk_idPart_auto AS idPart, 
DATE_FORMAT(_05_datIniTorn, "%d-%m-%Y") AS datIniTorn,
DATE_FORMAT(_06_datFinTorn, "%d-%m-%Y") AS datFinTorn, 
DATE_FORMAT(_06_datBaixaPart, "%d-%m-%Y %H:%i:%s") AS datBaixaPart

FROM

partida AS PP
LEFT JOIN torneigTePartida ON (_02_pk_idMaqTTP = _01_pk_idMaqPart AND
							          _03_pk_idJocTTP = _02_pk_idJocPart AND
						         	 _04_pk_idJugTTP = _03_pk_idJugPart )
INNER JOIN torneig 			ON ( _01_pk_idTornTTP = _01_pk_idTorn AND
										  _03_pk_idJocTTP  = _02_pk_idJocTorn)
INNER JOIN joc 				ON (_02_pk_idJocTorn = _01_pk_idJoc),

(SELECT _01_pk_idUsuari, _02_nomUsuari AS nomJug,_04_loginUsuari AS loginJug FROM usuari) AS BB

WHERE _03_pk_idJugPart = BB._01_pk_idUsuari

GROUP BY idUser, idJoc, idMaq
ORDER BY idUser, idJoc, idMaq,  datHoraPartida



/************************************************************************************/
/* 3.b.3 - 3130 - anul.lar / bloquejar  partides   */
/************************************************************************************/


UPDATE partida SET _05_datModPart  = NOW(),
						 _06_datBaixaPart  = NOW()
WHERE 
		_06_datBaixaPart IS NULL AND
		
		 	/*  canviar pel id de partida */	
		 	
		_00_pk_idPart_auto = "$idPartida";

/*
SELECT * FROM PARTIDA;
UPDATE partida SET _06_datBaixaPart  = NOW()
WHERE 
		_06_datBaixaPart IS NULL AND
		_00_pk_idPart_auto = "1";
SELECT * FROM PARTIDA;

*/

/************************************************************************************/
/* 3.b.4 - 3140 - desanul.lar / desbloquejar  partides   */
/************************************************************************************/

UPDATE partida SET _05_datModPart  = NOW(),
						_06_datBaixaPart  = NULL
WHERE 
		_06_datBaixaPart IS NOT NULL AND
		
		 	/*  canviar pel id de partida */	
		 	
		_00_pk_idPart_auto = "$idPartida";

/*

UPDATE partida SET _06_datBaixaPart  = NULL
WHERE 
		_06_datBaixaPart IS NOT NULL AND
		_00_pk_idPart_auto = "1";

*/


/************************************************************************************/
/* 3.b.5 - 3150 - Modificació de rondes de partides*/
/************************************************************************************/


UPDATE ronda SET _06_fotoJugRonda = "$fotoJug",
		   		  _07_puntsRonda   = "$puntsRonda",
					  _08_datModRonda  = NOW()
WHERE
		_09_datBaixaRonda IS NULL AND
		_00_pk_idRonda_auto = "$idRonda";


/************************************************************************************/
/* 3.b.6 - 3160 - llistar rondes de partides per manteniment*/
/************************************************************************************/

SELECT _01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn, _04_premiTorn AS premiTorn,
_02_pk_idJocTorn AS idJoc, JJ.nomJoc AS nomJoc,_02_pk_idMaqTTP AS idMaq,
BB.idUsuari AS idUser, BB.loginUsuari AS loginUser, BB.nomUsuari AS nomUser,
_00_pk_idPArt_auto AS idPart,
DATE_FORMAT(_04_pk_idDatHoraPart, "%d-%m-%Y %H:%i:%s") AS datHoraPartida,
_05_pk_idRonda AS rondaPart, _06_fotoJugRonda   AS fotoJugRonda,_07_puntsRonda AS punts

FROM
torneig
LEFT JOIN torneigTePartida ON (_01_pk_idTorn = _01_pk_idTornTTP AND _02_pk_idJocTorn = _03_pk_idJocTTP)
INNER JOIN partida ON (_02_pk_idMaqTTP = _01_pk_idMaqPart AND
							  _03_pk_idJocTTP = _02_pk_idJocPart AND
							  _04_pk_idJugTTP = _03_pk_idJugPart )
INNER JOIN ronda ON ( _01_pk_idMaqPart = _01_pk_idMaqRonda AND
							 _02_pk_idJocPart = _02_pk_idJocRonda AND
							 _03_pk_idJugPart = _03_pk_idJugRonda AND
							 _04_pk_idDatHoraPart = _04_pk_idDatHoraPartRonda ),

(SELECT _01_pk_idUsuari AS idUsuari, _02_nomUsuari AS nomUsuari, _04_loginUsuari AS loginUsuari FROM usuari) AS BB,

(SELECT _01_pk_idJoc, _02_nomJoc AS nomJoc FROM joc) AS JJ

WHERE
	BB.idUsuari     = _03_pk_idJugPart AND
	JJ._01_pk_idJoc = _02_pk_idJocPart AND
		_09_datBaixaTorn IS NULL AND
	_06_datBaixaPart IS NULL
		
GROUP BY idTorn, idUsuari, idMaq, datHoraPartida, idPart, rondaPart
ORDER BY idTorn, idUsuari, idMaq, datHoraPartida, idPart, rondaPart;

/******************************/

SELECT _01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn, _04_premiTorn AS premiTorn,
_02_pk_idJocTorn AS idJoc, JJ.nomJoc AS nomJoc,_02_pk_idMaqTTP AS idMaq,
BB.idUsuari AS idUser, BB.loginUsuari AS loginUser, BB.nomUsuari AS nomUser,
_00_pk_idPArt_auto AS idPart,
DATE_FORMAT(_04_pk_idDatHoraPart, "%d-%m-%Y %H:%i:%s") AS datHoraPartida,
_05_pk_idRonda AS rondaPart, _06_fotoJugRonda   AS fotoJugRonda,_07_puntsRonda AS punts

FROM
torneig
LEFT JOIN torneigTePartida ON (_01_pk_idTorn = _01_pk_idTornTTP AND _02_pk_idJocTorn = _03_pk_idJocTTP)
INNER JOIN partida ON (_02_pk_idMaqTTP = _01_pk_idMaqPart AND
							  _03_pk_idJocTTP = _02_pk_idJocPart AND
							  _04_pk_idJugTTP = _03_pk_idJugPart )
INNER JOIN ronda1 ON ( _00_pk_idPart_auto = _01_pk_idPartRonda ),

(SELECT _01_pk_idUsuari AS idUsuari, _02_nomUsuari AS nomUsuari, _04_loginUsuari AS loginUsuari FROM usuari) AS BB,

(SELECT _01_pk_idJoc, _02_nomJoc AS nomJoc FROM joc) AS JJ

WHERE
	BB.idUsuari     = _03_pk_idJugPart AND
	JJ._01_pk_idJoc = _02_pk_idJocPart AND
		_09_datBaixaTorn IS NULL AND
	_06_datBaixaPart IS NULL
		
GROUP BY idTorn, idUsuari, idMaq, datHoraPartida, idPart, rondaPart
ORDER BY idTorn, idUsuari, idMaq, datHoraPartida, idPart, rondaPart;


/************************************************************************************/
/* 3.b.7 - 3170 - llistar partides rondes de partides HISTÒRIC  */
/************************************************************************************/

SELECT _01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn, _04_premiTorn AS premiTorn,
_02_pk_idJocTorn AS idJoc, JJ.nomJoc AS nomJoc,_02_pk_idMaqTTP AS idMaq,
BB.idUsuari AS idUser, BB.loginUsuari AS loginUser, BB.nomUsuari AS nomUser,
_00_pk_idPArt_auto AS idPart,
DATE_FORMAT(_04_pk_idDatHoraPart, "%d-%m-%Y %H:%i:%s") AS datHoraPartida,
_05_pk_idRonda AS rondaPart, _06_fotoJugRonda AS fotoJugRonda, _07_puntsRonda AS punts,
DATE_FORMAT(_05_datModPart, "%d-%m-%Y %H:%i:%s") AS datModPart,
DATE_FORMAT(_06_datBaixaPart, "%d-%m-%Y %H:%i:%s") AS datBaixaPart

FROM
torneig
LEFT JOIN torneigTePartida ON (_01_pk_idTorn = _01_pk_idTornTTP AND _02_pk_idJocTorn = _03_pk_idJocTTP)
INNER JOIN partida ON (_02_pk_idMaqTTP = _01_pk_idMaqPart AND
							  _03_pk_idJocTTP = _02_pk_idJocPart AND
							  _04_pk_idJugTTP = _03_pk_idJugPart )
INNER JOIN ronda ON ( _01_pk_idMaqPart = _01_pk_idMaqRonda AND
							 _02_pk_idJocPart = _02_pk_idJocRonda AND
							 _03_pk_idJugPart = _03_pk_idJugRonda AND
							 _04_pk_idDatHoraPart = _04_pk_idDatHoraPartRonda ),

(SELECT _01_pk_idUsuari AS idUsuari, _02_nomUsuari AS nomUsuari, _04_loginUsuari AS loginUsuari FROM usuari) AS BB,

(SELECT _01_pk_idJoc, _02_nomJoc AS nomJoc FROM joc) AS JJ

WHERE
	BB.idUsuari     = _03_pk_idJugRonda AND
	JJ._01_pk_idJoc = _02_pk_idJocRonda
		
GROUP BY idTorn, idUsuari, idMaq, datHoraPartida, idPart, rondaPart
ORDER BY idTorn, idUsuari, idMaq, datHoraPartida, idPart, rondaPart;


/************************************************************************************/
/* 3.c.1 - 3230 - llistat de jocs   */
/************************************************************************************/

SELECT _01_pk_idjoc AS idJoc, _02_nomJoc AS nomJoc, _05_numPartidesJugadesJoc AS numPartides,
DATE_FORMAT(_06_datAltaJoc,  "%d-%m-%Y %H:%i:%s") AS datAltaJoc,
DATE_FORMAT(_07_datModJoc, "%d-%m-%Y %H:%i:%s")   AS datModJoc

FROM joc
WHERE _08_datBaixaJoc IS NULL;


/************************************************************************************/
/* 3.c.2 - 3240 -llistat de jocs històric  */
/************************************************************************************/

SELECT _01_pk_idjoc AS idJoc, _02_nomJoc AS nomJoc, _04_imgJoc AS imgJoc, 
_05_numPartidesJugadesJoc AS numPartides,
DATE_FORMAT(_06_datAltaJoc,  "%d-%m-%Y %H:%i:%s") AS datAltaJoc,
DATE_FORMAT(_07_datModJoc, "%d-%m-%Y %H:%i:%s")   AS datModJoc,
DATE_FORMAT(_08_datBaixaJoc, "%d-%m-%Y %H:%i:%s") AS datBaixaJoc

FROM joc;

/************************************************************************************/
/* 3.c.3 - 3210 - alta d'un joc   */
/************************************************************************************/

/* canviar les variables */

INSERT INTO joc VALUES (NULL,"$nomJoc","$descJoc","$imgJoc",0,NOW(),NULL,NULL);

/*
SELECT * FROM joC;
INSERT INTO joc VALUES (NULL,"ABC","DEF","DDD.JPG",0,NOW(),NULL,NULL);
SELECT * FROM joC;

*/


/************************************************************************************/
/* 3.c.4 - 3220 - baixa d'un joc   */
/* implica bloquejar el torneig associat i les màquines associades */
/************************************************************************************/


UPDATE joc SET _08_datBaixaJoc = NOW()

WHERE 

/* canviar variables per valors  */

		_01_pk_idJoc = "$idJoc" AND
		_08_datBaixaJoc IS NULL;

UPDATE torneig SET _09_datBaixaTorn = NOW()

WHERE 
		_02_pk_idJocTorn = "$idJoc" AND
		_09_datBaixaTorn IS NULL;

UPDATE maqinstall SET _08_datBaixaMaqInst = NOW()

WHERE 
		_02_pk_idJocInst = "$idJoc" AND
		_08_datBaixaMaqInst IS NULL;

/*

UPDATE joc SET _08_datBaixaJoc = NOW()

WHERE 
		_01_pk_idJoc = "104" AND
		_08_datBaixaJoc IS NULL;
SELECT * FROM JOC;
*/

/************************************************************************************/
/* 3.c.5 - 3225 - modificació d'un joc   */
/************************************************************************************/

/* canviar variables per valors  */

UPDATE joc SET  	  _02_nomJoc      = "$nomJoc",
						  _03_descJoc     = "$descJoc",
						  _04_imgJoc      = "$imgJoc",
						  _06_datAltaJoc  = "$dataAltaJoc",
						  _07_datModJoc   = NOW(),
						  _08_datBaixaJoc = "$dataBaixaJoc"						  

WHERE _01_pk_idJoc = "$idJoc";

/*

UPDATE joc SET  	  _02_nomJoc      = "RRRTTT",
						  _03_descJoc     = "HGJ",
						  _04_imgJoc      = "ABV.JPG",
						  _06_datAltaJoc  = "2014-06-22 10:10:10",
						  _07_datModJoc   = NOW(),
						  _08_datBaixaJoc = NULL				  

WHERE _01_pk_idJoc = "106";
SELECT * FROM JOC;

*/

/************************************************************************************/
/* 3.c.6 - 3270 - actualització de partides jugades a un joc   */
/************************************************************************************/

/* canviar variables per valors  */

UPDATE joc SET _05_numPartidesJugadesJoc = "$partides",
					_07_datModJoc = NOW()

WHERE 
		_01_pk_idJoc = "$idJoc" AND
		_08_datBaixaJoc IS NULL;
		
/*

UPDATE joc SET _05_numPartidesJugadesJoc = "8",
					_07_datModJoc = NOW()

WHERE 
		_01_pk_idJoc = "106" AND
		_08_datBaixaJoc IS NULL;
SELECT * FROM JOC;

*/

/************************************************************************************/
/*  3.c.7 - 3250 - Llistat de jocs amb les màquines a on estan instal.lats i amb num de partides jugades i crédits   */
/************************************************************************************/

SELECT _01_pk_idJoc AS idJoc, _02_nomJoc AS nomJoc, _01_pk_idMaq AS idMaq, _02_macMaq AS macMaq,
_03_numPartidesJugadesMaqInst AS numPartides, _05_totCredJocMaqInst AS totalCredit

FROM joc
LEFT JOIN maqInstall ON _01_pk_idJoc     = _02_pk_idJocInst
INNER JOIN maquina   ON _01_pk_idMaqInst = _01_pk_idMaq

WHERE 	
	_08_datBaixaJoc      IS NULL AND
	_08_datBaixaMaqInst  IS NULL AND
	_08_datBaixaMaq      IS NULL
	
GROUP BY idJoc,idMaq
ORDER BY idJoc,idMaq;


/************************************************************************************/
/*  3.c.8 - 3260 - Llistat de jocs amb les màquines a on estan instal.lats i amb num de partides jugades i crédits   */
/*                 Històric */
/************************************************************************************/

SELECT _01_pk_idJoc AS idJoc, _02_nomJoc AS nomJoc, _01_pk_idMaq AS idMaq, _02_macMaq AS macMaq,
_03_numPartidesJugadesMaqInst AS numPartides, _05_totCredJocMaqInst AS totalCredit,
DATE_FORMAT(_06_datAltaJoc,  "%d-%m-%Y %H:%i:%s") AS datAltaJoc,
DATE_FORMAT(_07_datModJoc,   "%d-%m-%Y %H:%i:%s") AS datModJoc,
DATE_FORMAT(_08_datBaixaJoc, "%d-%m-%Y %H:%i:%s") AS datBaixaJoc

FROM joc
LEFT JOIN maqInstall ON _01_pk_idJoc     = _02_pk_idJocInst
INNER JOIN maquina   ON _01_pk_idMaqInst = _01_pk_idMaq
	
GROUP BY idJoc,idMaq
ORDER BY idJoc,idMaq;

/************************************************************************************/
/*  3.d.1 - 3310 - alta d'un torneig   */
/************************************************************************************/

/* canviar les variables */

INSERT INTO torneig 
VALUES (NULL,"$idJoc","$nomTorn","$premiTorn","$dataIniciTorn","$dataFinTorn",NOW(),NULL,NULL);


/*
INSERT INTO torneig 
VALUES (NULL,"103","MI CASA","1100","2014-06-10","2014-07-23",NOW(),NULL,NULL);
SELECT * FROM TORNEIG;
*/

/************************************************************************************/
/*  3.d.2 - 3320 - Baixa d'un torneig   */
/************************************************************************************/


UPDATE torneig SET _09_datBaixaTorn = NOW()

WHERE 

/* canviar variables per valors  */

		_01_pk_idTorn    = "$idTorn" AND
		_02_pk_idJocTorn = "$idJoc" AND
		_09_datBaixaTorn IS NULL;


/*

UPDATE torneig SET _09_datBaixaTorn = NOW()

WHERE 

		_01_pk_idTorn    = "1006" AND
		_02_pk_idJocTorn = "103" AND
		_09_datBaixaTorn IS NULL;
SELECT * FROM TORNEIG;
*/

/************************************************************************************/
/*  3.d.3 - 3330 - Modificació d'un torneig   */
/************************************************************************************/

/* canviar variables per valors  */

UPDATE torneig SET _03_nomTorn     = "$nomTorn",
					    _04_premiTorn   = "$premiTorn",
		   	       _05_datIniTorn  = "$dataIniTorn",
						 _06_datFinTorn  = "$dataFinTorn",
						 _07_datAltaTorn = "$dataAltaTorn",
						 _08_datModTorn  = NOW(),
						 _09_datBaixaTorn = "$dataBaixaTorn"						 

WHERE 
		_01_pk_idTorn    = "$idTorn" AND
		_02_pk_idJocTorn = "$idJoc";

/*
UPDATE torneig SET _03_nomTorn     = "MI PISO",
					    _04_premiTorn   = "2200",
		   	       _05_datIniTorn  = "2014-05-10",
						 _06_datFinTorn  = "2014-07-22",
						 _07_datAltaTorn = "2014-05-05 10:10:10",
						 _08_datModTorn  = NOW(),
						 _09_datBaixaTorn = NULL					 

WHERE 
		_01_pk_idTorn    = "1006" AND
		_02_pk_idJocTorn = "103";
SELECT * FROM TORNEIG;
*/

/***********************************************************************************************/
/* 3.d.4 - 3340 - llistat de torneigs amb el premi, codi de joc i máquines que tenen instal.lat el joc */
/***********************************************************************************************/

SELECT _01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn, _04_premiTorn AS premiTorn, _01_pk_idJoc AS idJoc,
_02_nomJoc AS nomJoc,
DATE_FORMAT(_05_datIniTorn, "%d-%m-%Y") AS datIniTorn,
DATE_FORMAT(_06_datFinTorn, "%d-%m-%Y") AS datFinTorn, 
_01_pk_idMaq AS idMaq, _02_macMaq as macMaq,
DATE_FORMAT(_09_datBaixaTorn, "%d-%m-%Y %H:%i:%s") AS datBaixaTorn
FROM torneig

LEFT JOIN joc         ON _02_pk_idJocTorn = _01_pk_idJoc
INNER JOIN maqInstall ON _01_pk_idJoc     = _02_pk_idJocInst
INNER JOIN maquina    ON _01_pk_idMaqInst = _01_pk_idMaq

GROUP BY idTorn,idMaq;


/***********************************************************************************************/
/* 3.d.5 - 3350 - llistat de torneigs amb els jugadors registrats amb el seu nom, el codi de joc i el nom del joc */
/* incloent els torneigs amb cap jugador registrat
/***********************************************************************************************/

SELECT _01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn, _04_premiTorn AS premiTorn,
_02_pk_idJocTorn AS idJoc, BB.nomJoc AS nomJoc,
_01_pk_idJug AS idUser, _04_loginUsuari AS loginUser, _02_nomUsuari AS nomUser,
DATE_FORMAT(_05_datIniTorn,  "%d-%m-%Y") AS datIniTorn,
DATE_FORMAT(_06_datFinTorn,  "%d-%m-%Y") AS datFinTorn,
DATE_FORMAT(_07_datAltaTorn, "%d-%m-%Y %H:%i:%s") AS datAltaTorn,
DATE_FORMAT(_08_datModTorn,  "%d-%m-%Y %H:%i:%s") AS datModTorn

FROM

torneig
LEFT JOIN inscrit  ON (_01_pk_idTorn = _01_pk_idTornInsc  AND _02_pk_idJocTorn = _02_pk_idJocInsc )
INNER JOIN jugador ON _01_pk_idJug  = _03_pk_idJugInsc
INNER JOIN usuari  ON _01_pk_idJug  = _01_pk_idUsuari,

(SELECT _01_pk_idJoc, _02_nomJoc AS nomJoc FROM joc) AS BB

WHERE
	_02_pk_idJocTorn = BB._01_pk_idJoc AND
	_09_datBaixaTorn   IS NULL AND
	_10_datBaixaUsuari IS NULL
	
ORDER BY idTorn, idUser;




/***********************************************************************************************/
/* 3.d.6 - 3360 - llistat de torneigs amb els jugadors registrats amb el seu nom, el codi de joc i el nom del joc */
/* incloent els torneigs amb cap jugador registrat. Històric
/***********************************************************************************************/

SELECT _01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn, _04_premiTorn AS premiTorn,
_02_pk_idJocTorn AS idJoc, BB.nomJoc AS nomJoc,
_01_pk_idJug AS idUser, _04_loginUsuari AS loginUser, _02_nomUsuari AS nomUser,
DATE_FORMAT(_05_datIniTorn,  "%d-%m-%Y") AS datIniTorn,
DATE_FORMAT(_06_datFinTorn,  "%d-%m-%Y") AS datFinTorn,
DATE_FORMAT(_09_datBaixaTorn, "%d-%m-%Y %H:%i:%s") AS datBaixaTorn,
DATE_FORMAT(_10_datBaixaUsuari, "%d-%m-%Y %H:%i:%s") AS datBaixaUser

FROM

torneig
LEFT JOIN inscrit  ON (_01_pk_idTorn = _01_pk_idTornInsc  AND _02_pk_idJocTorn = _02_pk_idJocInsc )
INNER JOIN jugador ON _01_pk_idJug  = _03_pk_idJugInsc
INNER JOIN usuari  ON _01_pk_idJug  = _01_pk_idUsuari,

(SELECT _01_pk_idJoc, _02_nomJoc AS nomJoc FROM joc) AS BB

WHERE
	_02_pk_idJocTorn = BB._01_pk_idJoc
	
ORDER BY idTorn, idUser;


/***********************************************************************************************/
/* 3.d.7 - 3380 - llistat de torneigs amb el premi, codi de joc i máquines que tenen instal.lat el joc */
/* i els jugadors registrats a cada torneig amb les partides, rondes i punts obtinguts */
/***********************************************************************************************/

SELECT _01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn, _04_premiTorn AS premiTorn,
_02_pk_idJocTorn AS idJoc, CC.nomJoc AS nomJoc, _02_pk_idMaqTTP AS idMaq, BB.idUsuari AS idUser, BB.nomJug AS nomUser,
_05_pk_idRonda AS rondaPart, _07_puntsRonda AS punts,
DATE_FORMAT(_04_pk_idDatHoraPart, "%d-%m-%Y %H:%i:%s") AS datHoraPartida

FROM
(SELECT _01_pk_idUsuari AS idUsuari ,_02_nomUsuari AS nomJug FROM usuari) AS BB,
(SELECT _01_pk_idJoc AS idJoc, _02_nomJoc AS nomJoc FROM joc) AS CC,
torneig
LEFT JOIN torneigTePartida ON (_01_pk_idTorn = _01_pk_idTornTTP AND _02_pk_idJocTorn = _03_pk_idJocTTP)
INNER JOIN partida ON (_02_pk_idMaqTTP = _01_pk_idMaqPart AND
							  _03_pk_idJocTTP = _02_pk_idJocPart AND
							  _04_pk_idJugTTP = _03_pk_idJugPart )
INNER JOIN ronda ON ( _01_pk_idMaqPart = _01_pk_idMaqRonda AND
							 _02_pk_idJocPart = _02_pk_idJocRonda AND
							 _03_pk_idJugPart = _03_pk_idJugRonda AND
							 _04_pk_idDatHoraPart = _04_pk_idDatHoraPartRonda )						  

WHERE 
	BB.idUsuari = _03_pk_idJugPart AND
	CC.idJoc    = _02_pk_idJocPart AND
	_09_datBaixaTorn IS NULL AND
	_06_datBaixaPart IS NULL
	
GROUP BY idTorn,idMaq,idUsuari,datHoraPartida,rondaPart
ORDER BY idTorn,idMaq,idUsuari,datHoraPartida,rondaPart;


/***********************************************************************************************/
/* 3.d.8 - 3390 - llistat de torneigs amb el premi, codi de joc i máquines que tenen instal.lat el joc */
/* i els jugadors registrats a cada torneig amb les partides, rondes i punts obtinguts. Històric */
/***********************************************************************************************/


SELECT _01_pk_idTorn AS idTorn, _03_nomTorn AS nomTorn, _04_premiTorn AS premiTorn,
_02_pk_idJocTorn AS idJoc, CC.nomJoc AS nomJoc, _02_pk_idMaqTTP AS idMaq, BB.idUsuari AS idUser, BB.nomJug AS nomUser,
_05_pk_idRonda AS rondaPart, _07_puntsRonda AS punts,
DATE_FORMAT(_04_pk_idDatHoraPart, "%d-%m-%Y %H:%i:%s") AS datHoraPartida,
DATE_FORMAT(_09_datBaixaTorn, "%d-%m-%Y %H:%i:%s") AS datBaixaTorn,
DATE_FORMAT(_06_datBaixaPart, "%d-%m-%Y %H:%i:%s") AS datBaixaPart

FROM
(SELECT _01_pk_idUsuari AS idUsuari ,_02_nomUsuari AS nomJug FROM usuari) AS BB,
(SELECT _01_pk_idJoc AS idJoc, _02_nomJoc AS nomJoc FROM joc) AS CC,
torneig
LEFT JOIN torneigTePartida ON (_01_pk_idTorn = _01_pk_idTornTTP AND _02_pk_idJocTorn = _03_pk_idJocTTP)
INNER JOIN partida ON (_02_pk_idMaqTTP = _01_pk_idMaqPart AND
							  _03_pk_idJocTTP = _02_pk_idJocPart AND
							  _04_pk_idJugTTP = _03_pk_idJugPart )
INNER JOIN ronda ON ( _01_pk_idMaqPart = _01_pk_idMaqRonda AND
							 _02_pk_idJocPart = _02_pk_idJocRonda AND
							 _03_pk_idJugPart = _03_pk_idJugRonda AND
							 _04_pk_idDatHoraPart = _04_pk_idDatHoraPartRonda )						  
WHERE

	BB.idUsuari = _03_pk_idJugPart AND
	CC.idJoc    = _02_pk_idJocPart

GROUP BY idTorn,idMaq,idUsuari,datHoraPartida,rondaPart
ORDER BY idTorn,idMaq,idUsuari,datHoraPartida,rondaPart;



