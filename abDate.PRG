* abDate.prg
* =====================================================
* (c) Abaque SARL, 66 rue Michel Ange - 75016 Paris - France
* contact@FoxInCloud.com - http://www.FoxInCloud.com/ - +33 9 53 41 90 90
* -----------------------------------------------------
* Ce logiciel est distribu� sous licence MIT, tel quel, sans aucune garantie
* Il peut �tre utilis� et/ou redistribu� sans restriction
* Toute modification doit �tre revers�e � la communaut�
* La pr�sente mention doit �tre int�gralement reproduite dans toute copie m�me partielle
* -----------------------------------------------------
* This software is distributed under the terms of a MIT-style license, AS IS, without any warranty 
* It may be used and/or distributed without restriction
* Any substantial improvement must be given for free to the community
* This permission notice shall be entirely included in all copies or substantial portions of the Software
* =====================================================

#INCLUDE AB.H
#DEFINE DATE_SEP	'/|.:;$,'
#DEFINE SIXTY	60

AB()
return abUnitTests()

* ================================================
FUNCTION cJJHHMMSS && {fr} "JJ j HH:MM:SS" d'apr�s une dur�e en secondes {en}
LPARAMETERS ;
	tnSecs,; && Nombre de secondes
	tlFixedLen && [.F.] Taille fixe (15 caract�res)
LOCAL lcResult
lcResult = Space(Iif(m.tlFixedLen, 15, 0))

IF Vartype(m.tnSecs) == 'N' ;
 AND m.tnSecs >= 0
 
 	LOCAL lnDays, lcDays
 	lnDays = Int(m.tnSecs / 3600 / 24)
 	lcDays = Iif(m.lnDays > 0, lTrim(Str(m.lnDays)) + ' j ', Space(0))
 	lcResult = Textmerge([<<m.lcDays>><<cHHMMSS(Mod(m.tnSecs, 24*3600))>>])
ENDIF

RETURN m.lcResult

* ---------------------------------------------------------
PROCEDURE cJJHHMMSS_test && Teste cJJHHMMSS()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test("1 j 01:00:00", 25*3600)
loTest.Test("23:00:00", 23*3600)

RETURN loTest.Result()

* ================================================
FUNCTION cHHMMSS && HH:MM:SS d'apr�s une dur�e en secondes
LPARAMETERS ;
	tnSecs,; && Nombre de secondes
	tlFixedLen,; && [.F.] Taille fixe (8 caract�res)
	tlLtrim && [.F.] Supprimer les heures si = 0

LOCAL lnHours, lnMins, lnSecs, lcResult
lcResult = Space(Iif(m.tlFixedLen, 8, 0))

IF Vartype(m.tnSecs) == 'N' ;
 AND m.tnSecs >= 0

	STORE 0 to m.lnHours, m.lnMins
	lnSecs = Round(m.tnSecs, 0)

	IF m.lnSecs >= SIXTY
		lnMins = Int(m.lnSecs / SIXTY)
		lnSecs = Mod(m.lnSecs, SIXTY)
		IF m.lnMins >= SIXTY
			lnHours = Int(m.lnMins / SIXTY)
			lnMins = Mod(m.lnMins, SIXTY)
		ENDIF
	ENDIF

	lcResult = ;
		Iif(Vartype(m.tlLtrim) == 'L' AND m.tlLtrim AND m.lnHours = 0;
			, Space(Iif(m.tlFixedLen, 3, 0));
			, Padl(Ltrim(Str(m.lnHours)), 2, '0') + ':');
	+	Padl(Ltrim(Str(m.lnMins)), 2, '0') + ':';
	+	Padl(Ltrim(Str(m.lnSecs)), 2, '0')
ENDIF

RETURN m.lcResult

* ---------------------------------------------------------
PROCEDURE cHHMMSS_test && Teste cHHMMSS()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test("00:00:00", 00)
loTest.Test("00:00:59", 59)
loTest.Test("00:01:00", 59.9)
loTest.Test("00:01:00", 60)
loTest.Test("00:01:00", 60.1)
loTest.Test("00:01:01", 61)
loTest.Test("00:59:59", 3600-1)
loTest.Test("01:00:01", 3600+1)
loTest.Test("24:00:10", 24*3600+10)
loTest.Test("99:00:00", 99*3600)
loTest.Test(Space(0), -1)

RETURN loTest.Result()

* ================================================
FUNCTION cHHMMSecs && HH:MM d'apr�s une dur�e en secondes
LPARAMETERS tnSecs && Nombre de minutes
LOCAL lcResult

lcResult = cHHMMSS(m.tnSecs)
IF NOT Empty(m.lcResult)

	lcResult = Left(m.lcResult, 5)
ENDIF

RETURN m.lcResult

* ================================================
FUNCTION cHHMM && HH:MM d'apr�s une dur�e en minutes
LPARAMETERS tnMins && Nombre de minutes
LOCAL lcResult

lcResult = cHHMMSecs(m.tnMins * SIXTY)

RETURN m.lcResult

* ---------------------------------------------------------
PROCEDURE cHHMM_test && Teste cHHMM()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test("02:05", 125)

RETURN loTest.Result()

* ================================================
FUNCTION cYMDHMS && "Y,M,D,H,M,S" d'apr�s une date ou dateTime
LPARAMETERS ;
	tuDate,; && [DateTime()] Date ou dateTime
	tlJS && Javascript

LOCAL luDate, lcType, liJS, lcResult

luDate = Iif(Vartype(m.tuDate) $ 'DT', m.tuDate, Datetime())
lcType = Vartype(m.luDate)
liJS = Iif(Vartype(m.tlJS) == 'L' AND m.tlJS, -1, 0) && base 0 en javascript

lcResult = cWords(',' ;
	, lTrim(Str(Year(m.luDate)));
	, lTrim(Str(Month(m.luDate) + m.liJS));
	, lTrim(Str(Day(m.luDate)));
	)
IF m.lcType == 'T'
	lcResult = cWords(',' ;
		, m.lcResult;
		, lTrim(Str(Hour(m.luDate) + m.liJS));
		, lTrim(Str(Minute(m.luDate) + m.liJS));
		, lTrim(Str(Sec(m.luDate) + m.liJS));
		)
ENDIF

RETURN m.lcResult

* ================================================
FUNCTION nYear && Ann�e avec ou sans si�cle, -1 si invalide
LPARAMETERS tuYear && Contient l'ann�e pr�sum�e (CNDT)

LOCAL lcType

lcType = Vartype(m.tuYear)

RETURN ICase(;
	m.lcType == 'N',;
		m.tuYear,;
	m.lcType == 'C' AND IsDigit(Alltrim(m.tuYear)),;
		Val(m.tuYear),;
	m.lcType $ 'DT',;
		Year(m.tuYear),;
		-1;
	)

* ================================================
FUNCTION lYear && Ce nombre peut �tre consid�r� comme une ann�e
LPARAMETERS tnYear && Ann�e pr�sum�e

RETURN .T.;
 AND Vartype(m.tnYear) == 'N' ;
 AND m.tnYear - Int(m.tnYear) = 0 ; && enti�re
 AND Between(tnYear, 0, 3000)

* ================================================
FUNCTION nYearCent && Ann�e avec le si�cle
LPARAMETERS tuYear && Ann�e avec ou sans le si�cle (CNDT)

LOCAL lnYear
lnYear = nYear(m.tuYear)

#DEFINE CENT_CURRENT Int(Year(Date())/100)*100
#DEFINE CENT_ROLLOVER Year(Date()) - CENT_CURRENT + 30 && -70 ans � + 30 ans

RETURN ICase(;
	!lYear(m.lnYear),;
		0,;
	m.lnYear >= 100,;&& ann�e avec si�cle
		m.lnYear,;
		CENT_CURRENT - Iif(m.lnYear > CENT_ROLLOVER, 100, 0) + m.lnYear;
	)

* -----------------------------------------------------
PROCEDURE nYearCent_test && Teste nYearCent()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test(0, 2004.25)
loTest.Test(2004, 2004)
loTest.Test(2004, 04)
loTest.Test(2033, 33)
loTest.Test(2040, 40)
loTest.Test(1999, 99)

RETURN loTest.Result()

* ================================================
FUNCTION cYearCent && Ann�e avec le si�cle
LPARAMETERS tuYear && Ann�e avec ou sans le si�cle (CNDT)

LOCAL lnYearCent

lnYearCent = nYearCent(m.tuYear)

RETURN Iif(m.lnYearCent = 0, Space(0), lTrim(Str(m.lnYearCent)))

* ---------------------------------------------------------
PROCEDURE cYearCent_test && Teste cYearCent

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test(Space(0), '2004,25')
loTest.Test('2004', '2004')
loTest.Test('2004', '04')
loTest.Test('2033', '33')
loTest.Test('1940', '40')
loTest.Test('1999', '99')

RETURN loTest.Result()

* ================================================
FUNCTION nYearNoCent && Ann�e sans le si�cle
LPARAMETERS tuYear && Ann�e avec ou sans le si�cle (CNDT)

LOCAL lnYear

lnYear = nYear(m.tuYear)

RETURN ICase(;
	!lYear(m.lnYear),;
		-1,;
	m.lnYear < 100,;&& ann�e sans si�cle
		m.lnYear,;
		m.lnYear - Int(m.lnYear / 100) * 100;
	)

* ---------------------------------------------------------
PROCEDURE nYearNoCent_test && teste nYearNoCent

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test(-1, 4.25)
loTest.Test(00, 2000)
loTest.Test(4, 2004)
loTest.Test(33, 2033)
loTest.Test(40, 2040)
loTest.Test(99, 1999)

RETURN loTest.Result()

* ================================================
FUNCTION cYearNoCent && Ann�e sans le si�cle
LPARAMETERS tuYear && Ann�e avec ou sans le si�cle (CNDT)

LOCAL lnYearNoCent

lnYearNoCent = nYearNoCent(m.tuYear)

RETURN Iif(m.lnYearNoCent >= 0;
	, Padl(lTrim(Str(m.lnYearNoCent)), 2, '0');
	, '';
	)

* ---------------------------------------------------------
PROCEDURE cYearNoCent_test && teste cYearNoCent()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test(Space(0), 4.25)
loTest.Test('00', 2000)
loTest.Test('04', 2004)
loTest.Test('33', 2033)
loTest.Test('40', 2040)
loTest.Test('99', 1999)

RETURN loTest.Result()

* ================================================
FUNCTION cYearOrder && Ordre de tri des ann�es
LPARAMETERS tuYear && Ann�e avec ou sans le si�cle (CNDT)

RETURN Evl(cYearCent(m.tuYear), '0000')

* ================================================
FUNCTION nMonth && N� de mois compris entre 1 et 12
LPARAMETERS tnMonth && n� de Mois

RETURN Iif(Vartype(m.tnMonth)=='N';
	, Min(Max(m.tnMonth;
			, 01); && janvier
			, 12); && d�cembre
	, 0;
	)

* ================================================
FUNCTION cMMAA && Date MM/AA � partir d'un date JJ/MM/AA avec ou sans JJ et MM ou des MM et AA s�par�s
LPARAMETERS ;
	tcDate,; && @ Date compl�te [[JJ/]MM/]AA[AA]
	tcMois,; && @ [''] Mois s�par�
	tcAn	 && @ [''] An s�par�

LOCAL lcResult
lcResult = Space(0)

IF  .F.;
 OR Vartype(m.tcDate) = 'C' AND ! Empty(m.tcDate) ;
 OR Vartype(m.tcMois) = 'C'  AND ! Empty(m.tcMois) ;
 OR Vartype(m.tcAn) = 'C' AND ! Empty(m.tcAn)
	
	IF ! Empty(m.tcDate)	 &&	Date fournie compl�te
		tcDate = allTrim (m.tcDate)

		* Localiser les �ventuels s�parateurs entre jours, mois et ann�e
		LOCAL lnPosSepJM, lnPosSepMA
		lnPosSepJM = nAtSep (m.tcDate, DATE_SEP)
		lnPosSepMA = nRAtSep (m.tcDate, DATE_SEP)
		IF m.lnPosSepMA > 1
			lnPosSepJM = Iif(m.lnPosSepJM = m.lnPosSepMA, 0, m.lnPosSepJM)
			tcMois = cFigures(subStr (m.tcDate, m.lnPosSepJM + 1, m.lnPosSepMA - 1))
		ELSE 
			tcMois = Space(0)
		ENDIF
		IF m.lnPosSepMA >= 0
			tcAn = cFigures(subStr (m.tcDate, m.lnPosSepMA + 1))
		EndIF
	EndIf

	Local llAnNul, llMoisNul
	llMoisNul = empty(m.tcMois)
	llAnNul = empty(m.tcAn) && 00 pour 2000 n'est pas un an nul
	IF m.llAnNul AND !m.llMoisNul && l'ann�e a �t� pass�e � la place du mois
		tcAn = m.tcMois
		tcMois = Space(0)
		llAnNul = .F.
	ENDIF

	* Ann�e: Ajuster le si�cle
	IF ! m.llAnNul AND Len (m.tcAn) <= 2 &&	Ann�e � deux chiffres
		LOCAL lnAn, lcSiecle
		lnAn = Val (m.tcAn)
		lcSiecle = Iif(m.lnAn <= 50,; &&	Ann�e entre 2000 et 2050
							'20', '19')
		tcAn = m.lcSiecle + padL (allTrim (str (m.lnAn)), 2, '0')
	EndIF

	llMoisNul = Val(m.tcMois) = 0
	tcMois = Iif(m.llMoisNul, Space(0), PadL(Alltrim(m.tcMois), 2, '0'))

	tcDate = '';
		+ Iif(m.llMoisNul, Space(0), allTrim (m.tcMois));
		+ Iif(m.llMoisNul OR m.llAnNul, Space(0), '/');
		+ Iif(m.llAnNul, Space(0), Iif(m.llMoisNul, m.tcAn, Right(Alltrim(m.tcAn), 2))) &&	Ne garder que les ann�es !

	lcResult = m.tcDate
ENDIF && Vartype(tcDate) = 'C' ...

RETURN m.lcResult

* ---------------------------------------------------------
PROCEDURE cMMAA_test && Test de cMMAA()
?
? Sys(16)
? 'N�  Retour  R�sultats'
LOCAL i, lcDate, lcMois, lcAn, llResult
FOR m.i = 1 TO 9
	STORE '' TO m.lcDate, m.lcMois, m.lcAn
	DO CASE
	CASE m.i = 1
	CASE m.i = 2
		lcMois= '10'
		lcAn = '56'
	CASE m.i = 3
		lcDate = '12/2001'
	CASE m.i = 4
		lcDate = '.12/96-'
	CASE m.i = 5
		lcDate = '00-->'
	CASE m.i = 6
		lcMois= '00'
		lcAn = 'toto'
		lcDate = '1984   '
	CASE m.i = 7
		lcDate = '  89'
	CASE m.i = 8
		lcDate = '1986/02'
	CASE m.i = 9
		lcDate = '01/11/1989'
	ENDCASE
	lcResult = cMMAA (@m.lcDate, @m.lcMois, @m.lcAn)
	? Str(m.i, 2) + '.'
	?? m.lcResult + ' = ' + m.lcMois + '/' + m.lcAn + ' - ' + m.lcDate
ENDFOR

* ================================================
FUNCTION cMMAAofXL1900 && Date "MM/AA" � partir d'un date en nombre excel base 1900
LPARAMETERS tuXL1900 && C|N nombre repr�sentant une date dans Excel, base 1900 (standard XL pour Windows)

RETURN Substr(cJJMMAAofXL1900(m.tuXL1900), 4)

* ================================================
FUNCTION cJJMMAAofXL1900 && Date "JJ/MM/AA" � partir d'un date en nombre excel base 1900
LPARAMETERS tuXL1900 && C|N nombre repr�sentant une date dans Excel, base 1900 (standard Excel pour Windows)

LOCAL lcResult; && Date "JJ/MM/AA"
, lcType;
, lnXL1900;
, loDate AS abSet of abDev.prg

lcResult = ''

lcType = Vartype(m.tuXL1900)
IF m.lcType $ 'CN'

	lnXL1900 = Iif(m.lcType == 'N', m.tuXL1900, Val(m.tuXL1900))
 	IF m.lnXL1900 > 0

	 	loDate = abSet('DATE', 'FRENCH')
		lcResult = Dtoc(Date(1899, 12, 30) + m.lnXL1900) && 00/01/1900 dans Excel
	ENDIF
ENDIF

RETURN m.lcResult

* -----------------------------------------------------------------
PROCEDURE cJJMMAAofXL1900_Test && teste cJJMMAAofXL1900(), nouvelle version

LOCAL loTest AS abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test('30/04/84', 30802) && 30/04/1984 dans excel
loTest.Test('01/05/84', 30803) && 01/05/1984 dans excel
loTest.Test('01/12/01', 37226)

RETURN loTest.Result()

* ================================================
FUNCTION cAAAAMM && <Ann�e>/<mois en 2 chiffres>
LPARAMETERS tu && [Date()] Date ou date & heure ou nombre AAAAMM
tu = Evl(m.tu, Date())

RETURN Padr(;
			Alltrim(Str(Year(m.tu)));
		+ '/';
		+ Padl(Alltrim(Str(Month(m.tu))), 2, '0');
		, 7)

* ================================================
FUNCTION cAAAA_MMMM && <Ann�e> <mois en toutes lettres>
LPARAMETERS tu && [Date()] Date ou date & heure ou nombre AAAAMM
tu = Evl(m.tu, Date())

LOCAL lcType, lnYear, lnMonth, ld, lcDate, llResult, lcResult
lcResult = Space(0)

lcType = Vartype(m.tu)
IF m.lcType == 'N' AND m.tu > 0
	tu = Int(m.tu)
	llResult = Between(m.tu, 1, 999912) && When using strict date formats, {^0001-01-01}, January 1st, 1 A.D to {^9999-12-31}, December 31st, 9999 A.D.
	ASSERT m.llResult MESSAGE cAssertMsg(Textmerge([<<Program()>> - donn�e invalide : <<m.tu>>]))
	IF m.llResult

		lnMonth = m.tu % 100
		llResult = Between(m.lnMonth, 1, 12)
		ASSERT m.llResult MESSAGE cAssertMsg(Textmerge([<<Program()>> - donn�e invalide : <<m.tu>>]))
		IF m.llResult
			
			lnYear = Int((m.tu-m.lnMonth)/100)
			tu = Date(m.lnYear, m.lnMonth, 1)
			lcType = 'D'
		ENDIF
	ENDIF
ENDIF

IF m.lcType $ 'DT'

	lcDate = Set("Date")
	SET DATE LONG
	lcResult = Dtoc(Iif(m.lcType == 'D', m.tu, Ttod(m.tu)))
	SET DATE &lcDate
	lcResult = GetWordNum(m.lcResult, 4) + Space(1) + GetWordNum(m.lcResult, 3)
ENDIF

RETURN Padr(m.lcResult, 15)

* ================================================
FUNCTION cDateOrder && Ordre d'une date (AAAAMMJJ)
LPARAMETERS tcDate && Date sous la forme [JJ][MM]AA[AA], s�par�e par '.', '/', ou '-'

LOCAL lcResult
lcResult = Space(8)

* Si une date valide a �t� pass�e
IF Vartype(m.tcDate) == 'C' ;
 AND Val(Chrtran(m.tcDate, DATE_SEP, Space(0))) > 0

	* Localiser les �ventuels s�parateurs d'an et de mois
	LOCAL lnSepAn, lnSepMois
	lnSepAn = nRatSep(m.tcDate, DATE_SEP, 1)
	lnSepMois = nRatSep(m.tcDate, DATE_SEP, 2)

	* Calculer l'an (avec le si�cle), le mois et le jour en num�rique
	LOCAL lnAn, lnMois, lnJour
	lnAn = nYearCent(Val(Substr(m.tcDate, m.lnSepAn + 1)))
	lnMois = Val(Substr(m.tcDate, m.lnSepMois + 1, m.lnSepAn - 1))
	lnMois = Iif(m.lnMois < 1 or m.lnMois > 12, 1, m.lnMois)
	lnJour = Val(Substr(m.tcDate, 1, m.lnSepMois - 1))
	lnJour = Iif(m.lnJour < 1 or m.lnJour > 31, 1, m.lnJour)
	
	* Calculer le r�sultat
	lcResult = Dtoc(Date(m.lnAn, m.lnMois, m.lnJour), 1) && 1 Returns the date in a format suitable for indexing
ENDIF

RETURN m.lcResult

* ------------------------------------------------
PROCEDURE cDateOrder_test

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test(Space(8), '')
loTest.Test('20010101', '01')
loTest.Test('20030101', '1.03')
loTest.Test('20030401', '4.03')
loTest.Test('20030402', '2.4.03')

RETURN loTest.Result()

* ================================================
FUNCTION tDateCTime && Date et Heure d'apr�s la date et l'heure en caract�res (issue de aDir() par ex.)
LPARAMETERS ;
	td,; && Date
	tcTime && Heure en caract�res

RETURN Iif(Vartype(m.td) == 'D' ;
			 AND Vartype(m.tcTime) == 'C' ;
			 AND ':' $ m.tcTime;
		 , Ctot(Dtoc(m.td) + Space(1) + m.tcTime);
		 , .NULL.)

* ================================================
FUNCTION cDateLong && Date longue
LPARAMETERS ;
	tu,; && Date ou date-heure
	tlNoDay && [.F.] �ter le jour de la semaine

LOCAL lcResult;
, llResult;
, lcType;
, lcDate

lcResult = ''

lcType = Vartype(m.tu)
llResult = m.lcType $ 'DT'
ASSERT m.llResult MESSAGE cAssertMsg(Textmerge("<<Program()>> - Invalid parameter <<cLitteral(m.tu)>>"))
IF m.llResult

	lcDate = Set("Date")
	SET DATE LONG
	lcResult = Proper(Iif(m.lcType == 'T', Ttoc(m.tu), Dtoc(m.tu)))
	SET DATE &lcDate

	IF Vartype(m.tlNoDay) == 'L' AND m.tlNoDay
		lcResult = '';
			+ GetWordNum(m.lcResult, 2) + Space(1);
			+ GetWordNum(m.lcResult, 3) + Space(1);
			+ GetWordNum(m.lcResult, 4)
	ENDIF
ENDIF

RETURN m.lcResult

* ================================================
FUNCTION cDateLongAbbr && Jour en toutes lettres et date du mois
LPARAMETERS tu && Date ou date-heure

LOCAL lcResult;
, llResult;
, lcWords, lnWords

lcResult = Space(0)

lcWords = cDateLong(m.tu)
lnWords = GetWordCount(m.lcWords)
llResult = m.lnWords > 1
IF m.llResult
	
	lcResult = GetWordNum(m.lcWords, 1) + ' ' + GetWordNum(m.lcWords, 2)
ENDIF

RETURN m.lcResult

* ================================================
FUNCTION cMonthFR && Mois en fran�ais
LPARAMETERS tnMonth && N� du mois

RETURN ICase(;
		!Vartype(m.tnMonth) == 'N', Transform(m.tnMonth) + '?',;
		m.tnMonth = 01, 'janvier',;
		m.tnMonth = 02, 'f�vrier',;
		m.tnMonth = 03, 'mars',;
		m.tnMonth = 04, 'avril',;
		m.tnMonth = 05, 'mai',;
		m.tnMonth = 06, 'juin',;
		m.tnMonth = 07, 'juillet',;
		m.tnMonth = 08, 'ao�t',;
		m.tnMonth = 09, 'septembre',;
		m.tnMonth = 10, 'octobre',;
		m.tnMonth = 11, 'novembre',;
		m.tnMonth = 12, 'd�cembre',;
		Textmerge('n� de mois non support� : <<m.tnMonth>>');
		)

* ================================================
FUNCTION iAge && Age en ann�es enti�res
LPARAMETERS td
RETURN iYears(m.td, Date())

* ================================================
FUNCTION iYears && Ann�es enti�res entre deux dates ou date-heures
LPARAMETERS ;
	tdBeg,; && date ou date-heure d�but
	tdEnd && date ou date-heure fin

LOCAL llResult, lnMonthEnd, lnMonthBeg

llResult = Vartype(m.tdBeg) $ 'DT' AND Vartype(m.tdEnd) $ 'DT'
ASSERT m.llResult MESSAGE cAssertMsg(Textmerge([<<Program()>> - Deux param�tres date ou date-heure attendu eu lieu de <<cLitteral(m.tdBeg)>> et <<cLitteral(m.tdEnd)>>]))
IF m.llResult

	lnMonthEnd = Month(m.tdEnd)
	lnMonthBeg = Month(m.tdBeg)

	return Year(m.tdEnd);
		- Year(m.tdBeg) ;
		- Iif(.F.;
			or m.lnMonthEnd < m.lnMonthBeg;
			or m.lnMonthEnd = m.lnMonthBeg AND Day(m.tdEnd) < Day(m.tdBeg);
			, 1;
			, 0;
			)

else
	return .null.
ENDIF

* ---------------------------------------------------------
PROCEDURE iYears_test && Teste iYears()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test(6, Date(2000, 9, 15), Date(2007, 2, 15))
loTest.Test(7, Date(2000, 9, 15), Datetime(2007, 9, 15, 10, 0, 0))

RETURN loTest.Result()

* ================================================
FUNCTION iAgeMonths && Age en mois entiers
LPARAMETERS td
RETURN nMonths(m.td, Date())

* ================================================
FUNCTION iMonth && Mois � partir d'une valeur en caract�res
LPARAMETERS tcMonth
tcMonth = PROPER(cEuroANSI(LEFT(ALLTRIM(EVL(m.tcMonth, '')), 3)))

RETURN ICASE(;
	EMPTY(LEN(CHRTRAN(m.tcMonth, '01234856789', ''))) AND Between(CAST(m.tcMonth AS I), 1, 12), CAST(m.tcMonth AS I),;
	Len(TRIM(m.tcMonth)) < 3, .NULL.,;
	Inlist(m.tcMonth, 'Jan'), 01,;
	Inlist(m.tcMonth, 'Fev', 'Feb'), 02,;
	Inlist(m.tcMonth, 'Mar'), 03,;
	Inlist(m.tcMonth, 'Avr', 'Apr'), 04,;
	Inlist(m.tcMonth, 'Mai', 'May'), 05,;
	Inlist(m.tcMonth, 'Jun'), 06,;
	Inlist(m.tcMonth, 'Jui', 'Jul'), 07,;
	Inlist(m.tcMonth, 'Aou', 'Aug'), 08,;
	Inlist(m.tcMonth, 'Sep'), 09,;
	Inlist(m.tcMonth, 'Oct'), 10,;
	Inlist(m.tcMonth, 'Noc'), 11,;
	Inlist(m.tcMonth, 'Dec'), 12,;
	.NULL.;
)

* ================================================
FUNCTION nMonths && Nombre de mois entre deux dates ou dates-heure /!\ � renommer 'iMonths'
LPARAMETERS ;
	tu1,; && date ou date-heure de d�part
	tu2 && date ou date-heure d'arriv�e

RETURN Iif(Vartype(m.tu1) $ 'DT' AND Vartype(m.tu2) $ 'DT';
		, Month(m.tu2) - Month(m.tu1) + (Year(m.tu2) - Year(m.tu1)) * 12;
		, .null.;
		)

* ---------------------------------------------------------
PROCEDURE nMonths_test && Teste nMonths()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test(5, Date(2006, 9, 15), Date(2007, 2, 1))

RETURN loTest.Result()

* ================================================
FUNCTION nWeeks && Nombre de semaines (p�riodes de 7 jours) entre deux dates ou dates-heure
LPARAMETERS ;
	tdt1,; && date ou date-heure de d�part
	tdt2 && date ou date-heure d'arriv�e

LOCAL lcType1, lcType2, llResult, lnResult
lnResult = .NULL.

lcType1 = Vartype(m.tdt1)
lcType2 = Vartype(m.tdt2)
llResult = m.lcType1 $ 'DT' AND m.lcType2 $ 'DT'
ASSERT m.llResult MESSAGE cAssertMsg(Textmerge([<<Program()>> - Invalid parameters(s) type : <<m.tdt1>> or <<m.tdt2>> should be date or date-time]))
IF m.llResult

	lnResult = Floor((Iif(m.lcType2 == 'D', m.tdt2, Ttod(m.tdt2)) - Iif(m.lcType1 == 'D', m.tdt1, Ttod(m.tdt1)))/7)
ENDIF

RETURN m.lnResult

* ---------------------------------------------------------
PROCEDURE nWeeks_test && Teste nWeeks()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test(19, Date(2006, 9, 15), Date(2007, 2, 1))
loTest.Test(19, Datetime(2006, 9, 15), Date(2007, 2, 1))

RETURN loTest.Result()

* ================================================
FUNCTION nWeeksOld && �ge en semaines (p�riodes de 7 jours) d'une date ou date&heure
LPARAMETERS tdt && date ou date-heure
RETURN nWeeks(m.tdt, Date())

* ================================================
FUNCTION dWeekCurFirst && Date du premier jour de la semaine courante
LOCAL ld
ld = Date()
RETURN m.ld - Dow(m.ld,0) + 1

* ================================================
FUNCTION cdWeekCurFirst && Litt�ral date du premier jour de la semaine courante
RETURN cLitteral(dWeekCurFirst())

* ================================================
FUNCTION cYearWeek && AAAA|SS � partir d'une date ou d'une date-heure
LPARAMETERS ;
	tdt,; && date ou date&heure
	tcSep && ['|'] s�parateur entre l'ann�e et la semaine
tdt = Nvl(m.tdt, uEmpty('D'))
tcSep = Iif(Vartype(m.tcSep) == 'C' AND NOT Empty(m.tcSep), m.tcSep, '|')

RETURN Transform(Year(m.tdt), '@L 9999') + m.tcSep + Transform(Week(m.tdt,0,0), '@L 99')

* ================================================
FUNCTION dInC && Date � l'int�rieur d'une cha�ne de caract�res
LPARAMETERS ;
	tc && @ Cha�ne, au retour avec date �t�e
LOCAL loRegExp as abRegExp OF abtxt.prg, llResult, lcResult, ldResult

llResult = Vartype(m.tc) == 'C' AND NOT Empty(m.tc)
IF m.llResult
	
	loRegExp = CreateObject('abRegExp')
	loRegExp.Setup('\d+/\d+/\d\d+', .T., .T., .F.)
	llResult = loRegExp.Execute(m.tc) = 1
	IF m.llResult
		
		lcResult = loRegExp.matches[2]&& [index, valeur, submatches]
		ldResult = Ctod(m.lcResult)
		llResult = NOT Empty(m.ldResult)
		IF m.llResult
		
			tc = Strtran(m.tc, m.lcResult, Space(0))
		ENDIF
	ENDIF
ENDIF

RETURN Iif(m.llResult, m.ldResult, uEmpty('D'))

* ---------------------------------------------------------
PROCEDURE dInC_test && Teste dInC()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')
loTest.envSet('SET SYSFORMATS ON')

loTest.Test(Date(2008, 1, 12), "toto 12/1/2008")
loTest.Test(Date(2008, 2, 1), "toto 1/2/08 est le meilleur")
loTest.Test(uEmpty('D'), "toto 1/2/8 est le meilleur")

RETURN loTest.Result()

* ================================================
FUNCTION TtocSep && Ttoc(, 1) avec an, mois, jour, etc. s�par�s
LPARAMETERS ;
	tt,;
	tcSep && ['.'] s�parateur entre an, mois, jour, etc. 
tcSep = Left(Alltrim(Evl(m.tcSep, '.')), 1)

LOCAL lnLen, lnSep, lnPos, lcResult

lcResult = Ttoc(Evl(m.tt, Datetime()), 1)
lnLen = Len(m.lcResult)

FOR lnSep = 1 TO 5
	lnPos = m.lnLen - 2*m.lnSep 
	lcResult = Substr(m.lcResult, 1, m.lnPos) + m.tcSep + Substr(m.lcResult, m.lnPos+1)
NEXT

RETURN m.lcResult

* ================================================
FUNCTION DtocSep && Dtoc(, 1) avec an, mois, jour, etc. s�par�s
LPARAMETERS ;
	tt,;
	tcSep && ['.'] s�parateur entre an, mois, jour, etc.

RETURN Left(TtocSep(m.tt, m.tcSep), 10)

* ================================================
FUNCTION cSeconds && Secondes �coul�es tenant compte du passage par minuit pour affichage
LPARAMETERS tnSeconds && Seconds() au d�but, si @, Seconds() en retour

LOCAL lnResult
lnResult = nSeconds(@m.tnSeconds)

RETURN Iif(m.lnResult < 60, Transform(m.lnResult) + ' sec', cHHMMSS(m.lnResult))

* ================================================
FUNCTION nSeconds && Secondes �coul�es tenant compte du passage par minuit
LPARAMETERS tnSeconds && Seconds() au d�but, si @, Seconds() en retour
tnSeconds = Iif(Vartype(m.tnSeconds) == 'N' and m.tnSeconds > 0, m.tnSeconds, 0)

LOCAL lnSeconds, lnResult

lnSeconds = Seconds()

lnResult = m.lnSeconds - m.tnSeconds

* Tenir compte du passage �ventuel � minuit
lnResult = m.lnResult + Iif(m.lnResult >= 0;
	, 0;
	, 86400; && _Cliptext = Transform(24*3600)
	)

tnSeconds = m.lnSeconds && pour retour

RETURN m.lnResult

* ================================================
FUNCTION nMilliSeconds && Millisecondes �coul�es tenant compte du passage par minuit
LPARAMETERS tnSeconds && Seconds() au d�but, si @, Seconds() en retour

RETURN nMS(@m.tnSeconds)

* ================================================
FUNCTION nMS && Millisecondes �coul�es tenant compte du passage par minuit
LPARAMETERS tnSeconds && Seconds() au d�but, si @, Seconds() en retour

RETURN Int(nSeconds(@m.tnSeconds) * 1000)

* ================================================
FUNCTION cMS && Millisecondes �coul�es tenant compte du passage par minuit
LPARAMETERS tnSeconds && Seconds() au d�but, si @, Seconds() en retour

RETURN Transform(nMS(@m.tnSeconds)) + ' ms'

* ================================================
FUNCTION cDateTimeSep && Date et heure avec s�parateurs compatibles pour nom de fichier
LPARAMETERS tt && [Datetime()] Date et heure
RETURN Chrtran(Ttoc(Evl(m.tt, Datetime()), 3), ':', '.')

* ================================================
FUNCTION DtocXL && Date format�e selon masque de type Excel
LPARAMETERS ldDate, lsFormatExcel

ldDate = Evl(m.ldDate, Date())
lsFormatExcel = Evl(m.lsFormatExcel, "JJ/MM/AAAA") && on pourrait tenir compte de Set("Date") pour d�terminer le d�faut

* AAAA / YYYY = Ann�e avec si�cle
* AAA / YYY = Ann�e avec si�cle
* AA / YY = Ann�e sans le si�cle
* A / Y = Ann�e 1 chiffre
* MMMM = Nom du Mois
* MMM = 3 Premiere lettres du Nom du Mois
* MM  = n� mois sur 2 chiffres
* M  = n� du mois court
* JJJJ / DDD = Nom du Jour	
* JJJ / DDD = 3 premi�res lettres du nom du jour
* JJ / DD = n� de jour sur 2 chiffres
* J / D = n� du jour court

* Il ne faut pas remplacer ce qui a �t� substitu� exemple JJJJ -> "Jeudi" -> 7eudi
* et format possible anglais. Passage par <9999> Ann�e <8888> Mois <7777> Jours ...H M S a faire
* /!\ L'ordre des Strtran() a une importance : du plus long au plus court
RETURN Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Strtran(Chrtran(Upper(m.lsFormatExcel), 'YD', 'AJ');
	, "AAAA", "<9999>", 1);
	, "AAA", "<999>", 1);
	, "AA", "<99>", 1);
	, "A", "<9>", 1);
	, "MMMM", "<8888>", 1);
	, "MMM", "<888>", 1);
	, "MM", "<88>", 1);
	, "M", "<8>", 1);
	, "JJJJ", "<7777>", 1);
	, "JJJ", "<777>", 1);
	, "JJ", "<77>", 1);
	, "J", "<7>", 1);
	, "<9999>", Str(Year(m.ldDate),4,0), 1);
	, "<999>", Str(Year(m.ldDate),4,0), 1);
	, "<99>", Right(Str(Year(m.ldDate),4,0), 2), 1);
	, "<9>", Right(Str(Year(m.ldDate),4,0), 1), 1);
	, "<8888>", Proper(Cmonth(m.ldDate)), 1);
	, "<888>", Left(Proper(Cmonth(m.ldDate)),3), 1);
	, "<88>", Padl(Month(m.ldDate),2,"0"), 1);
	, "<8>", Alltrim(Str(Month(m.ldDate),2,0)), 1);
	, "<7777>", Proper(Cdow(m.ldDate)), 1);
	, "<777>", Left(Proper(CDOW(m.ldDate)),3), 1);
	, "<77>", Padl(Day(m.ldDate),2,"0"), 1);
	, "<7>", Alltrim(Str(Day(m.ldDate),2,0)), 1)

* ---------------------------------------------------------
PROCEDURE DtocXL_test && Teste DtocXL()

LOCAL loTest as abUnitTest OF abDev.prg
loTest = NewObject('abUnitTest', 'abDev.prg')

loTest.Test('12-06-07', Date(2012, 6, 7), 'yy-mm-jj') && 0,020 ms

RETURN loTest.Result()

* ----------------------------------------------
FUNCTION cDTformat_AW_XL && Format de date ou date-heure pour ActiveWidget ou Excel
LPARAMETERS ;
  tlT; && [.F.] Format de date et heure
, tlXL; && [.F.] Format pour Excel

tlXL = Vartype(m.tlXL) == 'L' and m.tlXL

LOCAL lcResult as String;
, lcDate as String;
, lcYear as String;
, lcMark as String;

lcDate = Set('Date')
lcYear = Iif(Set("Century") == 'ON', 'yyyy', 'yy')

lcResult = ICase(;
	m.lcDate == 'ANSI', m.lcYear + '.mm.dd',;
	m.lcDate == 'AMERICAN', 'mm/dd/' + m.lcYear,;
	m.lcDate == 'BRITISH', 'dd/mm/' + m.lcYear,;
	m.lcDate == 'FRENCH', 'dd/mm/' + m.lcYear,;
	m.lcDate == 'GERMAN', 'dd.mm.' + m.lcYear,;
	m.lcDate == 'ITALIAN', 'dd-mm-' + m.lcYear,;
	m.lcDate == 'JAPAN', m.lcYear + '/mm/dd',;
	m.lcDate == 'TAIWAN', m.lcYear + '/mm/dd',;
	m.lcDate == 'USA', 'mm-dd-' + m.lcYear,;
	m.lcDate == 'MDY', 'mm/dd/' + m.lcYear,;
	m.lcDate == 'DMY', 'dd/mm/' + m.lcYear,;
	m.lcDate == 'YMD', m.lcYear + '/mm/dd',;
	m.lcDate == 'SHORT', 'dd/mm/yy',; && Short date format determined by the Windows Control Panel short date setting /!\ � approfondir
	m.lcDate == 'LONG', 'dd/mm/yyyy',; && Long date format determined by the Windows Control Panel long date setting /!\ � approfondir
	'dd/mm/yyyy';
	)

lcMark = Set('Mark', 1)

RETURN '';
	+ Iif(Empty(m.lcMark);
		, m.lcResult;
		, Chrtran(m.lcResult, './-', Replicate(m.lcMark, Len('./-')));
		);
	+	Iif(Vartype(m.tlT) == 'L' AND m.tlT;
		, Space(1) + Iif(.F.;
				OR m.lcDate $ 'SHORT,LONG';  && � approfondir
			 	OR Set("Seconds") == 'ON';
			 , 'hh:mm:ss';
			 , 'hh:mm');
		, '';
		)

* ================================================
FUNCTION nWeeksYear && Nombre de semaines dans une ann�e
LPARAMETERS ;
	tnYear,; && Ann�e
	nFirstWeek,; && [1] premi�re semaine de l'ann�e selon Week()
	nFirstDayOfWeek && [1] premier jour de la semaine selon Week()
nFirstWeek = Iif(Pcount() >= 2 AND Vartype(m.nFirstWeek) == 'N' AND Int(m.nFirstWeek) = m.nFirstWeek AND Between(m.nFirstWeek, 0, 3), m.nFirstWeek, 1)
nFirstDayOfWeek = Iif(Pcount() >= 3 AND Vartype(m.nFirstDayOfWeek) == 'N' AND Int(m.nFirstDayOfWeek) = m.nFirstDayOfWeek AND Between(m.nFirstDayOfWeek, 0, 7), m.nFirstDayOfWeek, 1)

LOCAL ldResult, lnResult

ldResult = Date(m.tnYear, 12, 31)
DO WHILE .T.
	lnResult = Week(m.ldResult, m.nFirstWeek, m.nFirstDayOfWeek)
	IF m.lnResult > 1
		EXIT
	ELSE
		ldResult = m.ldResult - 1
	ENDIF
ENDDO

RETURN m.lnResult

* ================================================
FUNCTION cAgo && mention 'il y a'
lparameters ttd && date or datetime

local result as String;
, cType as String;
, lDate as Boolean;
, ltd;
, nAgo as Integer;
, nAgo_ as Integer;
, cAgo as String;
, cLangUser as String;

cType = Vartype(m.ttd)

if !m.cType $ 'DT'
	return .null.

else

	lDate = m.cType == 'D'
	ltd = Iif(m.lDate, Date(), Datetime())
	nAgo = m.ltd - m.ttd && > 0 if ttd is past
	nAgo_ = Abs(m.nAgo)
	nAgo_ = m.nAgo_ * Iif(m.cType == 'T', 1, 60*60*24)
	cLangUser = cLangUser()

	do case

	case m.lDate and Between(m.nAgo, -2, 2)
		do case
		case m.nAgo = 2
			cAgo = ICase(;
				m.cLangUser = 'fr',	[avant-hier],; && copy-paste this line to add another language support
														[day before yesterday]; && default: English
				)
		case m.nAgo = 1
			cAgo = ICase(;
				m.cLangUser = 'fr',	[hier],; && copy-paste this line to add another language support
														[yesterday]; && default: English
				)
		case Empty(m.nAgo)
			cAgo = ICase(;
				m.cLangUser = 'fr',	[aujourd'hui],; && copy-paste this line to add another language support
														[today]; && default: English
				)
		case m.nAgo = -1
			cAgo = ICase(;
				m.cLangUser = 'fr',	[demain],; && copy-paste this line to add another language support
														[tomorrow]; && default: English
				)
		case m.nAgo = -2
			cAgo = ICase(;
				m.cLangUser = 'fr',	[apr�s-demain],; && copy-paste this line to add another language support
														[day after tomorrow]; && default: English
				)
		endcase
		store 0 to nAgo, nAgo_

	case m.nAgo_ < 60
		cAgo = ICase(;
			m.cLangUser = 'fr',	'seconde',; && copy-paste this line to add another language support
													'second'; && default: English
			)
	case m.nAgo_ < (60*60)
		nAgo_ = Round(m.nAgo_ / 60, 0)
		cAgo = ICase(;
			m.cLangUser = 'fr',	'minute',; && copy-paste this line to add another language support
													'minute'; && default: English
			)
	case m.nAgo_ < (60*60*24)
		nAgo_ = Round(m.nAgo_ / (60*60), 0)
		cAgo = ICase(;
			m.cLangUser = 'fr',	'heure',; && copy-paste this line to add another language support
													'hour'; && default: English
			)
	case m.nAgo_ < (60*60*24*7)
		nAgo_ = Round(m.nAgo_ / (60*60*24), 0)
		cAgo = ICase(;
			m.cLangUser = 'fr',	'jour',; && copy-paste this line to add another language support
													'day'; && default: English
			)
	case Between(m.ttd, Gomonth(Date(), -1), Gomonth(Date(), 1))
		nAgo_ = Round(m.nAgo_ / (60*60*24*7), 0)
		cAgo = ICase(;
			m.cLangUser = 'fr',	'semaine',; && copy-paste this line to add another language support
													'week'; && default: English
			)
	otherwise
		nAgo_ = Abs(nMonths(m.ltd, m.ttd))
		cAgo = ICase(;
			m.cLangUser = 'fr',	'mois',; && copy-paste this line to add another language support
													'month'; && default: English
			)
	endcase
	
	return '';
		+ ICase(;
			Empty(m.nAgo),;
				'',;
			m.nAgo > 0,; && ttd is past
				ICase(;
					m.cLangUser = 'fr',	'il y a ',; && copy-paste this line to add another language support
															''; && default: English
					),;
				ICase(;
					m.cLangUser = 'fr',	'dans ',; && copy-paste this line to add another language support
															'in '; && default: English
					);
			);
		+ nEvl(Evl(m.nAgo, ''), Ltrim(Str(m.nAgo_))+ ' ');
		+ Iif(m.nAgo_ > 1;
			, Trim(m.cAgo, 's') + 's';
			, m.cAgo;
			);
		+ ICase(;
			Empty(m.nAgo),;
				'',;
			m.nAgo > 0,; && ttd is past
				ICase(;
					m.cLangUser = 'fr',	'',; && copy-paste this line to add another language support
															' ago'; && default: English
					),;
				ICase(;
					m.cLangUser = 'fr',	'',; && copy-paste this line to add another language support
															''; && default: English
					);
			);
		+ ''

endif
endfunc

* ---------------------------------------------------------
PROCEDURE cAgo_test && Teste cAgo()

LOCAL loTest as abUnitTest OF abDev.prg, cLangUser
loTest = NewObject('abUnitTest', 'abDev.prg')

cLangUser = cLangUser()

cLangUser('en')
loTest.Test('today', Date())
loTest.Test('yesterday', Date()-1)
loTest.Test('2 seconds ago', DateTime()-2)
loTest.Test('2 minutes ago', DateTime()-2*60)
loTest.Test('2 hours ago', DateTime()-2*60*60)

cLangUser('fr')
loTest.Test('apr�s-demain', Date()+2)

cLangUser(m.cLangUser)

RETURN loTest.Result()

* ================================================
FUNCTION cDateFig_Long && Date eu chiffres et longue
LPARAMETERS ;
	tu,; && Date ou date-heure
	tlNoDay && [.F.] �ter le jour de la semaine

return Transform(m.tu) + ' (' + cDateLong(m.tu, m.tlNoDay) + ')'

* ================================================
FUNCTION ctRFC822 && Date et heure selon la norme RFC822
LPARAMETERS ;
	tt,; && [datetime()] date-heure
	tlGMT && [.F.] GMT

LOCAL lcType, laDays[7], laMonths[12], lnOffset, lcDate, lcSeconds, lcHours, lcTime, lcResult

lcType = Vartype(m.tt)
tt = ICase(m.lcType == 'T', m.tt;
		, m.lcType == 'D', Dtot(m.tt);
		, Datetime())
tlGMT = Vartype(m.tlGMT) == 'L' AND m.tlGMT

laDays[1] = "Mon" && Dow(, 2)
laDays[2] = "Tue"
laDays[3] = "Wed"
laDays[4] = "Thu"
laDays[5] = "Fri"
laDays[6] = "Sat"
laDays[7] = "Sun"
laMonths[01] = "Jan"
laMonths[02] = "Feb"
laMonths[03] = "Mar"
laMonths[04] = "Apr"
laMonths[05] = "May"
laMonths[06] = "Jun"
laMonths[07] = "Jul"
laMonths[08] = "Aug"
laMonths[09] = "Sep"
laMonths[10] = "Oct"
laMonths[11] = "Nov"
laMonths[12] = "Dec"

lnOffset = 'GetTimeZone' && �vite une d�pendance � wwAPI
lnOffset = Evaluate(m.lnOffset + '()')/60 && GetTimeZone() est en minutes && modify command wwAPI
IF m.tlGMT
	tt = m.tt + m.lnOffset * 3600
ENDIF

* Lire l'heure avec les secondes
lcDate = Set("Date")
lcHours = Transform(Set("Hours"))
lcSeconds = Set("Seconds")
SET DATE TO FRENCH && If DATE is set to SHORT or LONG, the SET CENTURY, SET MARK, SET HOURS, and SET SECONDS settings are ignored
SET HOURS TO 24 
SET SECONDS ON
lcTime = Ttoc(m.tt, 2) && HH:MM:SS
SET DATE TO &lcDate
SET HOURS TO &lcHours
SET SECONDS &lcSeconds

lcResult = Textmerge("<<laDays[Dow(m.tt, 2)]>>, <<Padl(Day(m.tt),2,'0')>> <<laMonths[Month(m.tt)]>> <<Str(Year(m.tt),4)>> <<m.lcTime>>");
	+ Iif(m.tlGMT, " GMT", Iif(m.lnOffset > 0," -"," +");
	+ Padl(Transform(Abs(m.lnOffSet)), 2, "0") + "00")

RETURN m.lcResult