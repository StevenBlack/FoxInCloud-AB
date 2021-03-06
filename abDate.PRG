* abDate.prg
* =====================================================
* (c) Abaque SARL, 66 rue Michel Ange - 75016 Paris - France
* contact@FoxInCloud.com - http://www.FoxInCloud.com/ - +33 9 53 41 90 90
* -----------------------------------------------------
* Ce logiciel est distribu� sous GNU General Public License, tel quel, sans aucune garantie
* Il peut �tre utilis� et/ou redistribu� sans restriction
* Toute modification doit �tre revers�e � la communaut�
* La pr�sente mention doit �tre int�gralement reproduite dans toute copie m�me partielle
* -----------------------------------------------------
* This software is distributed under the terms of GNU General Public License, AS IS, without any warranty
* It may be used and/or distributed without restriction
* Any substantial improvement must be given for free to the community
* This permission notice shall be entirely included in all copies or substantial portions of the Software
* =====================================================

#INCLUDE AB.H
#define DATE_SEP	'/|.:;$,'
#define SIXTY	60

AB()
return abUnitTests()

* ================================================
function cJJHHMMSS && {fr} "JJ j HH:MM:SS" d'apr�s une dur�e en secondes {en}
lparameters ;
	tnSecs,; && Nombre de secondes
	tlFixedLen && [.F.] Taille fixe (15 caract�res)
local lcResult
lcResult = space(iif(m.tlFixedLen, 15, 0))

if vartype(m.tnSecs) == 'N' ;
 and m.tnSecs >= 0

 	local lnDays, lcDays
 	lnDays = int(m.tnSecs / 3600 / 24)
 	lcDays = iif(m.lnDays > 0, ltrim(str(m.lnDays)) + ' j ', space(0))
 	lcResult = textmerge([<<m.lcDays>><<cHHMMSS(Mod(m.tnSecs, 24*3600))>>])
endif

return m.lcResult

* ---------------------------------------------------------
procedure cJJHHMMSS_test && Teste cJJHHMMSS()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test("1 j 01:00:00", 25*3600)
loTest.Test("23:00:00", 23*3600)

return loTest.Result()

* ================================================
function cHHMMSS && HH:MM:SS d'apr�s une dur�e en secondes
lparameters ;
	tnSecs,; && Nombre de secondes
	tlFixedLen,; && [.F.] Taille fixe (8 caract�res)
	tlLtrim && [.F.] Supprimer les heures si = 0

local lnHours, lnMins, lnSecs, lcResult
lcResult = space(iif(m.tlFixedLen, 8, 0))

if vartype(m.tnSecs) == 'N' ;
 and m.tnSecs >= 0

	store 0 to m.lnHours, m.lnMins
	lnSecs = round(m.tnSecs, 0)

	if m.lnSecs >= SIXTY
		lnMins = int(m.lnSecs / SIXTY)
		lnSecs = mod(m.lnSecs, SIXTY)
		if m.lnMins >= SIXTY
			lnHours = int(m.lnMins / SIXTY)
			lnMins = mod(m.lnMins, SIXTY)
		endif
	endif

	lcResult = ;
		iif(vartype(m.tlLtrim) == 'L' and m.tlLtrim and m.lnHours = 0;
			, space(iif(m.tlFixedLen, 3, 0));
			, padl(ltrim(str(m.lnHours)), 2, '0') + ':');
	+	padl(ltrim(str(m.lnMins)), 2, '0') + ':';
	+	padl(ltrim(str(m.lnSecs)), 2, '0')
endif

return m.lcResult

* ---------------------------------------------------------
procedure cHHMMSS_test && Teste cHHMMSS()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

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
loTest.Test(space(0), -1)

return loTest.Result()

* ================================================
function cHHMMSecs && HH:MM d'apr�s une dur�e en secondes
lparameters tnSecs && Nombre de minutes
local lcResult

lcResult = cHHMMSS(m.tnSecs)
if not empty(m.lcResult)

	lcResult = left(m.lcResult, 5)
endif

return m.lcResult

* ================================================
function cHHMM && HH:MM d'apr�s une dur�e en minutes
lparameters tnMins && Nombre de minutes
local lcResult

lcResult = cHHMMSecs(m.tnMins * SIXTY)

return m.lcResult

* ---------------------------------------------------------
procedure cHHMM_test && Teste cHHMM()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test("02:05", 125)

return loTest.Result()

* ================================================
function cYMDHMS && "Y,M,D,H,M,S" d'apr�s une date ou dateTime
lparameters ;
	tuDate,; && [DateTime()] Date ou dateTime
	tlJS && Javascript

local luDate, lcType, liJS, lcResult

luDate = iif(vartype(m.tuDate) $ 'DT', m.tuDate, datetime())
lcType = vartype(m.luDate)
liJS = iif(vartype(m.tlJS) == 'L' and m.tlJS, -1, 0) && base 0 en javascript

lcResult = cWords(',' ;
	, ltrim(str(year(m.luDate)));
	, ltrim(str(month(m.luDate) + m.liJS));
	, ltrim(str(day(m.luDate)));
	)
if m.lcType == 'T'
	lcResult = cWords(',' ;
		, m.lcResult;
		, ltrim(str(hour(m.luDate) + m.liJS));
		, ltrim(str(minute(m.luDate) + m.liJS));
		, ltrim(str(sec(m.luDate) + m.liJS));
		)
endif

return m.lcResult

* ================================================
function nYear && Ann�e avec ou sans si�cle, -1 si invalide
lparameters tuYear && Contient l'ann�e pr�sum�e (CNDT)

local lcType

lcType = vartype(m.tuYear)

return icase(;
	m.lcType == 'N',;
		m.tuYear,;
	m.lcType == 'C' and isdigit(alltrim(m.tuYear)),;
		val(m.tuYear),;
	m.lcType $ 'DT',;
		year(m.tuYear),;
		-1;
	)

* ================================================
function lYear && Ce nombre peut �tre consid�r� comme une ann�e
lparameters tnYear && Ann�e pr�sum�e

return .t.;
 and vartype(m.tnYear) == 'N' ;
 and m.tnYear - int(m.tnYear) = 0 ; && enti�re
 and between(tnYear, 0, 3000)

* ================================================
function nYearCent && Ann�e avec le si�cle
lparameters tuYear && Ann�e avec ou sans le si�cle (CNDT)

local lnYear
lnYear = nYear(m.tuYear)

#define CENT_CURRENT int(year(date())/100)*100
#define CENT_ROLLOVER year(date()) - CENT_CURRENT + 30 && -70 ans � + 30 ans

return icase(;
	!lYear(m.lnYear),;
		0,;
	m.lnYear >= 100,;&& ann�e avec si�cle
		m.lnYear,;
		CENT_CURRENT - iif(m.lnYear > CENT_ROLLOVER, 100, 0) + m.lnYear;
	)

* -----------------------------------------------------
procedure nYearCent_test && Teste nYearCent()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test(0, 2004.25)
loTest.Test(2004, 2004)
loTest.Test(2004, 04)
loTest.Test(2033, 33)
loTest.Test(2040, 40)
loTest.Test(1999, 99)

return loTest.Result()

* ================================================
function cYearCent && Ann�e avec le si�cle
lparameters tuYear && Ann�e avec ou sans le si�cle (CNDT)

local lnYearCent

lnYearCent = nYearCent(m.tuYear)

return iif(m.lnYearCent = 0, space(0), ltrim(str(m.lnYearCent)))

* ---------------------------------------------------------
procedure cYearCent_test && Teste cYearCent

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test(space(0), '2004,25')
loTest.Test('2004', '2004')
loTest.Test('2004', '04')
loTest.Test('2033', '33')
loTest.Test('1940', '40')
loTest.Test('1999', '99')

return loTest.Result()

* ================================================
function nYearNoCent && Ann�e sans le si�cle
lparameters tuYear && Ann�e avec ou sans le si�cle (CNDT)

local lnYear

lnYear = nYear(m.tuYear)

return icase(;
	!lYear(m.lnYear),;
		-1,;
	m.lnYear < 100,;&& ann�e sans si�cle
		m.lnYear,;
		m.lnYear - int(m.lnYear / 100) * 100;
	)

* ---------------------------------------------------------
procedure nYearNoCent_test && teste nYearNoCent

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test(-1, 4.25)
loTest.Test(00, 2000)
loTest.Test(4, 2004)
loTest.Test(33, 2033)
loTest.Test(40, 2040)
loTest.Test(99, 1999)

return loTest.Result()

* ================================================
function cYearNoCent && Ann�e sans le si�cle
lparameters tuYear && Ann�e avec ou sans le si�cle (CNDT)

local lnYearNoCent

lnYearNoCent = nYearNoCent(m.tuYear)

return iif(m.lnYearNoCent >= 0;
	, padl(ltrim(str(m.lnYearNoCent)), 2, '0');
	, '';
	)

* ---------------------------------------------------------
procedure cYearNoCent_test && teste cYearNoCent()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test(space(0), 4.25)
loTest.Test('00', 2000)
loTest.Test('04', 2004)
loTest.Test('33', 2033)
loTest.Test('40', 2040)
loTest.Test('99', 1999)

return loTest.Result()

* ================================================
function cYearOrder && Ordre de tri des ann�es
lparameters tuYear && Ann�e avec ou sans le si�cle (CNDT)

return evl(cYearCent(m.tuYear), '0000')

* ================================================
function nMonth && N� de mois compris entre 1 et 12
lparameters tnMonth && n� de Mois

return iif(vartype(m.tnMonth)=='N';
	, min(max(m.tnMonth;
			, 01); && janvier
			, 12); && d�cembre
	, 0;
	)

* ================================================
function cMMAA && Date MM/AA � partir d'un date JJ/MM/AA avec ou sans JJ et MM ou des MM et AA s�par�s
lparameters ;
	tcDate,; && @ Date compl�te [[JJ/]MM/]AA[AA]
	tcMois,; && @ [''] Mois s�par�
	tcAn	 && @ [''] An s�par�

local lcResult
lcResult = space(0)

if  .f.;
 or vartype(m.tcDate) = 'C' and ! empty(m.tcDate) ;
 or vartype(m.tcMois) = 'C'  and ! empty(m.tcMois) ;
 or vartype(m.tcAn) = 'C' and ! empty(m.tcAn)

	if ! empty(m.tcDate)	 &&	Date fournie compl�te
		tcDate = alltrim (m.tcDate)

* Localiser les �ventuels s�parateurs entre jours, mois et ann�e
		local lnPosSepJM, lnPosSepMA
		lnPosSepJM = nAtSep (m.tcDate, DATE_SEP)
		lnPosSepMA = nRAtSep (m.tcDate, DATE_SEP)
		if m.lnPosSepMA > 1
			lnPosSepJM = iif(m.lnPosSepJM = m.lnPosSepMA, 0, m.lnPosSepJM)
			tcMois = cFigures(substr (m.tcDate, m.lnPosSepJM + 1, m.lnPosSepMA - 1))
		else
			tcMois = space(0)
		endif
		if m.lnPosSepMA >= 0
			tcAn = cFigures(substr (m.tcDate, m.lnPosSepMA + 1))
		endif
	endif

	local llAnNul, llMoisNul
	llMoisNul = empty(m.tcMois)
	llAnNul = empty(m.tcAn) && 00 pour 2000 n'est pas un an nul
	if m.llAnNul and !m.llMoisNul && l'ann�e a �t� pass�e � la place du mois
		tcAn = m.tcMois
		tcMois = space(0)
		llAnNul = .f.
	endif

* Ann�e: Ajuster le si�cle
	if ! m.llAnNul and len (m.tcAn) <= 2 &&	Ann�e � deux chiffres
		local lnAn, lcSiecle
		lnAn = val (m.tcAn)
		lcSiecle = iif(m.lnAn <= 50,; &&	Ann�e entre 2000 et 2050
							'20', '19')
		tcAn = m.lcSiecle + padl (alltrim (str (m.lnAn)), 2, '0')
	endif

	llMoisNul = val(m.tcMois) = 0
	tcMois = iif(m.llMoisNul, space(0), padl(alltrim(m.tcMois), 2, '0'))

	tcDate = '';
		+ iif(m.llMoisNul, space(0), alltrim (m.tcMois));
		+ iif(m.llMoisNul or m.llAnNul, space(0), '/');
		+ iif(m.llAnNul, space(0), iif(m.llMoisNul, m.tcAn, right(alltrim(m.tcAn), 2))) &&	Ne garder que les ann�es !

	lcResult = m.tcDate
endif && Vartype(tcDate) = 'C' ...

return m.lcResult

* ---------------------------------------------------------
procedure cMMAA_test && Test de cMMAA()
?
? sys(16)
? 'N�  Retour  R�sultats'
local i, lcDate, lcMois, lcAn, llResult
for m.i = 1 to 9
	store '' to m.lcDate, m.lcMois, m.lcAn
	do case
	case m.i = 1
	case m.i = 2
		lcMois= '10'
		lcAn = '56'
	case m.i = 3
		lcDate = '12/2001'
	case m.i = 4
		lcDate = '.12/96-'
	case m.i = 5
		lcDate = '00-->'
	case m.i = 6
		lcMois= '00'
		lcAn = 'toto'
		lcDate = '1984   '
	case m.i = 7
		lcDate = '  89'
	case m.i = 8
		lcDate = '1986/02'
	case m.i = 9
		lcDate = '01/11/1989'
	endcase
	lcResult = cMMAA (@m.lcDate, @m.lcMois, @m.lcAn)
	? str(m.i, 2) + '.'
	?? m.lcResult + ' = ' + m.lcMois + '/' + m.lcAn + ' - ' + m.lcDate
endfor

* ================================================
function cMMAAofXL1900 && Date "MM/AA" � partir d'un date en nombre excel base 1900
lparameters tuXL1900 && C|N nombre repr�sentant une date dans Excel, base 1900 (standard XL pour Windows)

return substr(cJJMMAAofXL1900(m.tuXL1900), 4)

* ================================================
function cJJMMAAofXL1900 && Date "JJ/MM/AA" � partir d'un date en nombre excel base 1900
lparameters tuXL1900 && C|N nombre repr�sentant une date dans Excel, base 1900 (standard Excel pour Windows)

local lcResult; && Date "JJ/MM/AA"
, lcType;
, lnXL1900;
, loDate as abSet of abDev.prg

lcResult = ''

lcType = vartype(m.tuXL1900)
if m.lcType $ 'CN'

	lnXL1900 = iif(m.lcType == 'N', m.tuXL1900, val(m.tuXL1900))
 	if m.lnXL1900 > 0

	 	loDate = abSet('DATE', 'FRENCH')
		lcResult = dtoc(date(1899, 12, 30) + m.lnXL1900) && 00/01/1900 dans Excel
	endif
endif

return m.lcResult

* -----------------------------------------------------------------
procedure cJJMMAAofXL1900_Test && teste cJJMMAAofXL1900(), nouvelle version

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test('30/04/84', 30802) && 30/04/1984 dans excel
loTest.Test('01/05/84', 30803) && 01/05/1984 dans excel
loTest.Test('01/12/01', 37226)

return loTest.Result()

* ================================================
function cAAAAMM && <Ann�e>/<mois en 2 chiffres>
lparameters tu && [Date()] Date ou date & heure ou nombre AAAAMM
tu = evl(m.tu, date())

return padr(;
			alltrim(str(year(m.tu)));
		+ '/';
		+ padl(alltrim(str(month(m.tu))), 2, '0');
		, 7)

* ================================================
function cAAAA_MMMM && <Ann�e> <mois en toutes lettres>
lparameters tu && [Date()] Date ou date & heure ou nombre AAAAMM
tu = evl(m.tu, date())

local lcType, lnYear, lnMonth, ld, lcDate, llResult, lcResult
lcResult = space(0)

lcType = vartype(m.tu)
if m.lcType == 'N' and m.tu > 0
	tu = int(m.tu)
	llResult = between(m.tu, 1, 999912) && When using strict date formats, {^0001-01-01}, January 1st, 1 A.D to {^9999-12-31}, December 31st, 9999 A.D.
	assert m.llResult message cAssertMsg(textmerge([<<Program()>> - donn�e invalide : <<m.tu>>]))
	if m.llResult

		lnMonth = m.tu % 100
		llResult = between(m.lnMonth, 1, 12)
		assert m.llResult message cAssertMsg(textmerge([<<Program()>> - donn�e invalide : <<m.tu>>]))
		if m.llResult

			lnYear = int((m.tu-m.lnMonth)/100)
			tu = date(m.lnYear, m.lnMonth, 1)
			lcType = 'D'
		endif
	endif
endif

if m.lcType $ 'DT'

	lcDate = set("Date")
	set date long
	lcResult = dtoc(iif(m.lcType == 'D', m.tu, ttod(m.tu)))
	set date &lcDate
	lcResult = getwordnum(m.lcResult, 4) + space(1) + getwordnum(m.lcResult, 3)
endif

return padr(m.lcResult, 15)

* ================================================
function cDateOrder && Ordre d'une date (AAAAMMJJ)
lparameters tcDate && Date sous la forme [JJ][MM]AA[AA], s�par�e par '.', '/', ou '-'

local lcResult
lcResult = space(8)

* Si une date valide a �t� pass�e
if vartype(m.tcDate) == 'C' ;
 and val(chrtran(m.tcDate, DATE_SEP, space(0))) > 0

* Localiser les �ventuels s�parateurs d'an et de mois
	local lnSepAn, lnSepMois
	lnSepAn = nRAtSep(m.tcDate, DATE_SEP, 1)
	lnSepMois = nRAtSep(m.tcDate, DATE_SEP, 2)

* Calculer l'an (avec le si�cle), le mois et le jour en num�rique
	local lnAn, lnMois, lnJour
	lnAn = nYearCent(val(substr(m.tcDate, m.lnSepAn + 1)))
	lnMois = val(substr(m.tcDate, m.lnSepMois + 1, m.lnSepAn - 1))
	lnMois = iif(m.lnMois < 1 or m.lnMois > 12, 1, m.lnMois)
	lnJour = val(substr(m.tcDate, 1, m.lnSepMois - 1))
	lnJour = iif(m.lnJour < 1 or m.lnJour > 31, 1, m.lnJour)

* Calculer le r�sultat
	lcResult = dtoc(date(m.lnAn, m.lnMois, m.lnJour), 1) && 1 Returns the date in a format suitable for indexing
endif

return m.lcResult

* ------------------------------------------------
procedure cDateOrder_test

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test(space(8), '')
loTest.Test('20010101', '01')
loTest.Test('20030101', '1.03')
loTest.Test('20030401', '4.03')
loTest.Test('20030402', '2.4.03')

return loTest.Result()

* ================================================
function tDateCTime && Date et Heure d'apr�s la date et l'heure en caract�res (issue de aDir() par ex.)
lparameters ;
	td,; && Date
	tcTime && Heure en caract�res

return iif(vartype(m.td) == 'D' ;
			 and vartype(m.tcTime) == 'C' ;
			 and ':' $ m.tcTime;
		 , ctot(dtoc(m.td) + space(1) + m.tcTime);
		 , .null.)

* ================================================
function cDateLong && Date longue
lparameters ;
	tu,; && Date ou date-heure
	tlNoDay && [.F.] �ter le jour de la semaine

local lcResult;
, llResult;
, lcType;
, lcDate

lcResult = ''

lcType = vartype(m.tu)
llResult = m.lcType $ 'DT'
assert m.llResult message cAssertMsg(textmerge("<<Program()>> - Invalid parameter <<cLitteral(m.tu)>>"))
if m.llResult

	lcDate = set("Date")
	set date long
	lcResult = proper(iif(m.lcType == 'T', ttoc(m.tu), dtoc(m.tu)))
	set date &lcDate

	if vartype(m.tlNoDay) == 'L' and m.tlNoDay
		lcResult = '';
			+ getwordnum(m.lcResult, 2) + space(1);
			+ getwordnum(m.lcResult, 3) + space(1);
			+ getwordnum(m.lcResult, 4)
	endif
endif

return m.lcResult

* ================================================
function cDateLongAbbr && Jour en toutes lettres et date du mois
lparameters tu && Date ou date-heure

local lcResult;
, llResult;
, lcWords, lnWords

lcResult = space(0)

lcWords = cDateLong(m.tu)
lnWords = getwordcount(m.lcWords)
llResult = m.lnWords > 1
if m.llResult

	lcResult = getwordnum(m.lcWords, 1) + ' ' + getwordnum(m.lcWords, 2)
endif

return m.lcResult

* ================================================
function cMonthFR && Mois en fran�ais
lparameters tnMonth && N� du mois

return icase(;
		!vartype(m.tnMonth) == 'N', transform(m.tnMonth) + '?',;
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
		textmerge('n� de mois non support� : <<m.tnMonth>>');
		)

* ================================================
function iAge && Age en ann�es enti�res
lparameters td
return iYears(m.td, date())

* ================================================
function iYears && Ann�es enti�res entre deux dates ou date-heures
lparameters ;
	tdBeg,; && date ou date-heure d�but
	tdEnd && date ou date-heure fin

local llResult, lnMonthEnd, lnMonthBeg

llResult = vartype(m.tdBeg) $ 'DT' and vartype(m.tdEnd) $ 'DT'
assert m.llResult message cAssertMsg(textmerge([<<Program()>> - Deux param�tres date ou date-heure attendu eu lieu de <<cLitteral(m.tdBeg)>> et <<cLitteral(m.tdEnd)>>]))
if m.llResult

	lnMonthEnd = month(m.tdEnd)
	lnMonthBeg = month(m.tdBeg)

	return year(m.tdEnd);
		- year(m.tdBeg) ;
		- iif(.f.;
			or m.lnMonthEnd < m.lnMonthBeg;
			or m.lnMonthEnd = m.lnMonthBeg and day(m.tdEnd) < day(m.tdBeg);
			, 1;
			, 0;
			)

else
	return .null.
endif

* ---------------------------------------------------------
procedure iYears_test && Teste iYears()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test(6, date(2000, 9, 15), date(2007, 2, 15))
loTest.Test(7, date(2000, 9, 15), datetime(2007, 9, 15, 10, 0, 0))

return loTest.Result()

* ================================================
function iAgeMonths && Age en mois entiers
lparameters td
return nMonths(m.td, date())

* ================================================
function iMonth && Mois � partir d'une valeur en caract�res
lparameters tcMonth
tcMonth = proper(cEuroANSI(left(alltrim(evl(m.tcMonth, '')), 3)))

return icase(;
	empty(len(chrtran(m.tcMonth, '01234856789', ''))) and between(cast(m.tcMonth as i), 1, 12), cast(m.tcMonth as i),;
	len(trim(m.tcMonth)) < 3, .null.,;
	inlist(m.tcMonth, 'Jan'), 01,;
	inlist(m.tcMonth, 'Fev', 'Feb'), 02,;
	inlist(m.tcMonth, 'Mar'), 03,;
	inlist(m.tcMonth, 'Avr', 'Apr'), 04,;
	inlist(m.tcMonth, 'Mai', 'May'), 05,;
	inlist(m.tcMonth, 'Jun'), 06,;
	inlist(m.tcMonth, 'Jui', 'Jul'), 07,;
	inlist(m.tcMonth, 'Aou', 'Aug'), 08,;
	inlist(m.tcMonth, 'Sep'), 09,;
	inlist(m.tcMonth, 'Oct'), 10,;
	inlist(m.tcMonth, 'Noc'), 11,;
	inlist(m.tcMonth, 'Dec'), 12,;
	.null.;
)

* ================================================
function nMonths && Nombre de mois entre deux dates ou dates-heure /!\ � renommer 'iMonths'
lparameters ;
	tu1,; && date ou date-heure de d�part
	tu2 && date ou date-heure d'arriv�e

return iif(vartype(m.tu1) $ 'DT' and vartype(m.tu2) $ 'DT';
		, month(m.tu2) - month(m.tu1) + (year(m.tu2) - year(m.tu1)) * 12;
		, .null.;
		)

* ---------------------------------------------------------
procedure nMonths_test && Teste nMonths()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test(5, date(2006, 9, 15), date(2007, 2, 1))

return loTest.Result()

* ================================================
function nWeeks && Nombre de semaines (p�riodes de 7 jours) entre deux dates ou dates-heure
lparameters ;
	tdt1,; && date ou date-heure de d�part
	tdt2 && date ou date-heure d'arriv�e

local lcType1, lcType2, llResult, lnResult
lnResult = .null.

lcType1 = vartype(m.tdt1)
lcType2 = vartype(m.tdt2)
llResult = m.lcType1 $ 'DT' and m.lcType2 $ 'DT'
assert m.llResult message cAssertMsg(textmerge([<<Program()>> - Invalid parameters(s) type : <<m.tdt1>> or <<m.tdt2>> should be date or date-time]))
if m.llResult

	lnResult = floor((iif(m.lcType2 == 'D', m.tdt2, ttod(m.tdt2)) - iif(m.lcType1 == 'D', m.tdt1, ttod(m.tdt1)))/7)
endif

return m.lnResult

* ---------------------------------------------------------
procedure nWeeks_test && Teste nWeeks()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test(19, date(2006, 9, 15), date(2007, 2, 1))
loTest.Test(19, datetime(2006, 9, 15), date(2007, 2, 1))

return loTest.Result()

* ================================================
function nWeeksOld && �ge en semaines (p�riodes de 7 jours) d'une date ou date&heure
lparameters tdt && date ou date-heure
return nWeeks(m.tdt, date())

* ================================================
function dWeekCurFirst && Date du premier jour de la semaine courante
local ld
ld = date()
return m.ld - dow(m.ld,0) + 1

* ================================================
function cdWeekCurFirst && Litt�ral date du premier jour de la semaine courante
return cLitteral(dWeekCurFirst())

* ================================================
function cYearWeek && AAAA|SS � partir d'une date ou d'une date-heure
lparameters ;
	tdt,; && date ou date&heure
	tcSep && ['|'] s�parateur entre l'ann�e et la semaine
tdt = nvl(m.tdt, uEmpty('D'))
tcSep = iif(vartype(m.tcSep) == 'C' and not empty(m.tcSep), m.tcSep, '|')

return transform(year(m.tdt), '@L 9999') + m.tcSep + transform(week(m.tdt,0,0), '@L 99')

* ================================================
function dInC && Date � l'int�rieur d'une cha�ne de caract�res
lparameters ;
	tc && @ Cha�ne, au retour avec date �t�e
local loRegExp as abRegExp of abtxt.prg, llResult, lcResult, ldResult

llResult = vartype(m.tc) == 'C' and not empty(m.tc)
if m.llResult

	loRegExp = createobject('abRegExp')
	loRegExp.setup('\d+/\d+/\d\d+', .t., .t., .f.)
	llResult = loRegExp.Execute(m.tc) = 1
	if m.llResult

		lcResult = loRegExp.matches[2]&& [index, valeur, submatches]
		ldResult = ctod(m.lcResult)
		llResult = not empty(m.ldResult)
		if m.llResult

			tc = strtran(m.tc, m.lcResult, space(0))
		endif
	endif
endif

return iif(m.llResult, m.ldResult, uEmpty('D'))

* ---------------------------------------------------------
procedure dInC_test && Teste dInC()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')
loTest.envSet('SET SYSFORMATS ON')

loTest.Test(date(2008, 1, 12), "toto 12/1/2008")
loTest.Test(date(2008, 2, 1), "toto 1/2/08 est le meilleur")
loTest.Test(uEmpty('D'), "toto 1/2/8 est le meilleur")

return loTest.Result()

* ================================================
function TtocSep && Ttoc(, 1) avec an, mois, jour, etc. s�par�s
lparameters ;
	tt,;
	tcSep && ['.'] s�parateur entre an, mois, jour, etc.
tcSep = left(alltrim(evl(m.tcSep, '.')), 1)

local lnLen, lnSep, lnPos, lcResult

lcResult = ttoc(evl(m.tt, datetime()), 1)
lnLen = len(m.lcResult)

for lnSep = 1 to 5
	lnPos = m.lnLen - 2*m.lnSep
	lcResult = substr(m.lcResult, 1, m.lnPos) + m.tcSep + substr(m.lcResult, m.lnPos+1)
next

return m.lcResult

* ================================================
function DtocSep && Dtoc(, 1) avec an, mois, jour, etc. s�par�s
lparameters ;
	tt,;
	tcSep && ['.'] s�parateur entre an, mois, jour, etc.

return left(TtocSep(m.tt, m.tcSep), 10)

* ================================================
function cSeconds && Secondes �coul�es tenant compte du passage par minuit pour affichage
lparameters tnSeconds && Seconds() au d�but, si @, Seconds() en retour

local lnResult
lnResult = nSeconds(@m.tnSeconds)

return iif(m.lnResult < 60, transform(m.lnResult) + ' sec', cHHMMSS(m.lnResult))

* ================================================
function nSeconds && Secondes �coul�es tenant compte du passage par minuit
lparameters tnSeconds && Seconds() au d�but, si @, Seconds() en retour
tnSeconds = iif(vartype(m.tnSeconds) == 'N' and m.tnSeconds > 0, m.tnSeconds, 0)

local lnSeconds, lnResult

lnSeconds = seconds()

lnResult = m.lnSeconds - m.tnSeconds

* Tenir compte du passage �ventuel � minuit
lnResult = m.lnResult + iif(m.lnResult >= 0;
	, 0;
	, 86400; && _Cliptext = Transform(24*3600)
	)

tnSeconds = m.lnSeconds && pour retour

return m.lnResult

* ================================================
function nMilliSeconds && Millisecondes �coul�es tenant compte du passage par minuit
lparameters tnSeconds && Seconds() au d�but, si @, Seconds() en retour

return nMS(@m.tnSeconds)

* ================================================
function nMS && Millisecondes �coul�es tenant compte du passage par minuit
lparameters tnSeconds && Seconds() au d�but, si @, Seconds() en retour

return int(nSeconds(@m.tnSeconds) * 1000)

* ================================================
function cMS && Millisecondes �coul�es tenant compte du passage par minuit
lparameters tnSeconds && Seconds() au d�but, si @, Seconds() en retour

return transform(nMS(@m.tnSeconds)) + ' ms'

* ================================================
function cDateTimeSep && Date et heure avec s�parateurs compatibles pour nom de fichier
lparameters tt && [Datetime()] Date et heure
return chrtran(ttoc(evl(m.tt, datetime()), 3), ':', '.')

* ================================================
function DtocXL && Date format�e selon masque de type Excel
lparameters ldDate, lsFormatExcel

ldDate = evl(m.ldDate, date())
lsFormatExcel = evl(m.lsFormatExcel, "JJ/MM/AAAA") && on pourrait tenir compte de Set("Date") pour d�terminer le d�faut

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
return strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(strtran(chrtran(upper(m.lsFormatExcel), 'YD', 'AJ');
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
	, "<9999>", str(year(m.ldDate),4,0), 1);
	, "<999>", str(year(m.ldDate),4,0), 1);
	, "<99>", right(str(year(m.ldDate),4,0), 2), 1);
	, "<9>", right(str(year(m.ldDate),4,0), 1), 1);
	, "<8888>", proper(cmonth(m.ldDate)), 1);
	, "<888>", left(proper(cmonth(m.ldDate)),3), 1);
	, "<88>", padl(month(m.ldDate),2,"0"), 1);
	, "<8>", alltrim(str(month(m.ldDate),2,0)), 1);
	, "<7777>", proper(cdow(m.ldDate)), 1);
	, "<777>", left(proper(cdow(m.ldDate)),3), 1);
	, "<77>", padl(day(m.ldDate),2,"0"), 1);
	, "<7>", alltrim(str(day(m.ldDate),2,0)), 1)

* ---------------------------------------------------------
procedure DtocXL_test && Teste DtocXL()

local loTest as abUnitTest of abDev.prg
loTest = newobject('abUnitTest', 'abDev.prg')

loTest.Test('12-06-07', date(2012, 6, 7), 'yy-mm-jj') && 0,020 ms

return loTest.Result()

* ----------------------------------------------
function cDTformat_AW_XL && Format de date ou date-heure pour ActiveWidget ou Excel
lparameters ;
  tlT; && [.F.] Format de date et heure
, tlXL; && [.F.] Format pour Excel

tlXL = vartype(m.tlXL) == 'L' and m.tlXL

local lcResult as string;
, lcDate as string;
, lcYear as string;
, lcMark as string;

lcDate = set('Date')
lcYear = iif(set("Century") == 'ON', 'yyyy', 'yy')

lcResult = icase(;
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

lcMark = set('Mark', 1)

return '';
	+ iif(empty(m.lcMark);
		, m.lcResult;
		, chrtran(m.lcResult, './-', replicate(m.lcMark, len('./-')));
		);
	+	iif(vartype(m.tlT) == 'L' and m.tlT;
		, space(1) + iif(.f.;
				or m.lcDate $ 'SHORT,LONG';  && � approfondir
			 	or set("Seconds") == 'ON';
			 , 'hh:mm:ss';
			 , 'hh:mm');
		, '';
		)

* ================================================
function nWeeksYear && Nombre de semaines dans une ann�e
lparameters ;
	tnYear,; && Ann�e
	nFirstWeek,; && [1] premi�re semaine de l'ann�e selon Week()
	nFirstDayOfWeek && [1] premier jour de la semaine selon Week()
nFirstWeek = iif(pcount() >= 2 and vartype(m.nFirstWeek) == 'N' and int(m.nFirstWeek) = m.nFirstWeek and between(m.nFirstWeek, 0, 3), m.nFirstWeek, 1)
nFirstDayOfWeek = iif(pcount() >= 3 and vartype(m.nFirstDayOfWeek) == 'N' and int(m.nFirstDayOfWeek) = m.nFirstDayOfWeek and between(m.nFirstDayOfWeek, 0, 7), m.nFirstDayOfWeek, 1)

local ldResult, lnResult

ldResult = date(m.tnYear, 12, 31)
do while .t.
	lnResult = week(m.ldResult, m.nFirstWeek, m.nFirstDayOfWeek)
	if m.lnResult > 1
		exit
	else
		ldResult = m.ldResult - 1
	endif
enddo

return m.lnResult

* ================================================
function cAgo && mention 'il y a'
lparameters ttd && date or datetime

local Result as string;
, cType as string;
, lDate as Boolean;
, ltd;
, nAgo as integer;
, nAgo_ as integer;
, cAgo as string;
, cLangUser as string;

cType = vartype(m.ttd)

if !m.cType $ 'DT'
	return .null.

else

	lDate = m.cType == 'D'
	ltd = iif(m.lDate, date(), datetime())
	nAgo = m.ltd - m.ttd && > 0 if ttd is past
	nAgo_ = abs(m.nAgo)
	nAgo_ = m.nAgo_ * iif(m.cType == 'T', 1, 60*60*24)
	cLangUser = cLangUser()

	do case

	case m.lDate and between(m.nAgo, -2, 2)
		do case
		case m.nAgo = 2
			cAgo = icase(;
				m.cLangUser = 'fr',	[avant-hier],; && copy-paste this line to add another language support
														[day before yesterday]; && default: English
				)
		case m.nAgo = 1
			cAgo = icase(;
				m.cLangUser = 'fr',	[hier],; && copy-paste this line to add another language support
														[yesterday]; && default: English
				)
		case empty(m.nAgo)
			cAgo = icase(;
				m.cLangUser = 'fr',	[aujourd'hui],; && copy-paste this line to add another language support
														[today]; && default: English
				)
		case m.nAgo = -1
			cAgo = icase(;
				m.cLangUser = 'fr',	[demain],; && copy-paste this line to add another language support
														[tomorrow]; && default: English
				)
		case m.nAgo = -2
			cAgo = icase(;
				m.cLangUser = 'fr',	[apr�s-demain],; && copy-paste this line to add another language support
														[day after tomorrow]; && default: English
				)
		endcase
		store 0 to nAgo, nAgo_

	case m.nAgo_ < 60
		cAgo = icase(;
			m.cLangUser = 'fr',	'seconde',; && copy-paste this line to add another language support
													'second'; && default: English
			)
	case m.nAgo_ < (60*60)
		nAgo_ = round(m.nAgo_ / 60, 0)
		cAgo = icase(;
			m.cLangUser = 'fr',	'minute',; && copy-paste this line to add another language support
													'minute'; && default: English
			)
	case m.nAgo_ < (60*60*24)
		nAgo_ = round(m.nAgo_ / (60*60), 0)
		cAgo = icase(;
			m.cLangUser = 'fr',	'heure',; && copy-paste this line to add another language support
													'hour'; && default: English
			)
	case m.nAgo_ < (60*60*24*7)
		nAgo_ = round(m.nAgo_ / (60*60*24), 0)
		cAgo = icase(;
			m.cLangUser = 'fr',	'jour',; && copy-paste this line to add another language support
													'day'; && default: English
			)
	case between(m.ttd, gomonth(date(), -1), gomonth(date(), 1))
		nAgo_ = round(m.nAgo_ / (60*60*24*7), 0)
		cAgo = icase(;
			m.cLangUser = 'fr',	'semaine',; && copy-paste this line to add another language support
													'week'; && default: English
			)
	otherwise
		nAgo_ = abs(nMonths(m.ltd, m.ttd))
		cAgo = icase(;
			m.cLangUser = 'fr',	'mois',; && copy-paste this line to add another language support
													'month'; && default: English
			)
	endcase

	return '';
		+ icase(;
			empty(m.nAgo),;
				'',;
			m.nAgo > 0,; && ttd is past
				icase(;
					m.cLangUser = 'fr',	'il y a ',; && copy-paste this line to add another language support
															''; && default: English
					),;
				icase(;
					m.cLangUser = 'fr',	'dans ',; && copy-paste this line to add another language support
															'in '; && default: English
					);
			);
		+ nEvl(evl(m.nAgo, ''), ltrim(str(m.nAgo_))+ ' ');
		+ iif(m.nAgo_ > 1;
			, trim(m.cAgo, 's') + 's';
			, m.cAgo;
			);
		+ icase(;
			empty(m.nAgo),;
				'',;
			m.nAgo > 0,; && ttd is past
				icase(;
					m.cLangUser = 'fr',	'',; && copy-paste this line to add another language support
															' ago'; && default: English
					),;
				icase(;
					m.cLangUser = 'fr',	'',; && copy-paste this line to add another language support
															''; && default: English
					);
			);
		+ ''

endif
endfunc

* ---------------------------------------------------------
procedure cAgo_test && Teste cAgo()

local loTest as abUnitTest of abDev.prg, cLangUser
loTest = newobject('abUnitTest', 'abDev.prg')

cLangUser = cLangUser()

cLangUser('en')
loTest.Test('today', date())
loTest.Test('yesterday', date()-1)
loTest.Test('2 seconds ago', datetime()-2)
loTest.Test('2 minutes ago', datetime()-2*60)
loTest.Test('2 hours ago', datetime()-2*60*60)

cLangUser('fr')
loTest.Test('apr�s-demain', date()+2)

cLangUser(m.cLangUser)

return loTest.Result()

* ================================================
function cDateFig_Long && Date eu chiffres et longue
lparameters ;
	tu,; && Date ou date-heure
	tlNoDay && [.F.] �ter le jour de la semaine

return transform(m.tu) + ' (' + cDateLong(m.tu, m.tlNoDay) + ')'

* ================================================
function ctRFC822 && Date et heure selon la norme RFC822
lparameters ;
	tt,; && [datetime()] date-heure
	tlGMT && [.F.] GMT

local lcType, laDays[7], laMonths[12], lnOffset, lcDate, lcSeconds, lcHours, lcTime, lcResult

lcType = vartype(m.tt)
tt = icase(m.lcType == 'T', m.tt;
		, m.lcType == 'D', dtot(m.tt);
		, datetime())
tlGMT = vartype(m.tlGMT) == 'L' and m.tlGMT

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
lnOffset = evaluate(m.lnOffset + '()')/60 && GetTimeZone() est en minutes && modify command wwAPI
if m.tlGMT
	tt = m.tt + m.lnOffset * 3600
endif

* Lire l'heure avec les secondes
lcDate = set("Date")
lcHours = transform(set("Hours"))
lcSeconds = set("Seconds")
set date to french && If DATE is set to SHORT or LONG, the SET CENTURY, SET MARK, SET HOURS, and SET SECONDS settings are ignored
set hours to 24
set seconds on
lcTime = ttoc(m.tt, 2) && HH:MM:SS
set date to &lcDate
set hours to &lcHours
set seconds &lcSeconds

lcResult = textmerge("<<laDays[Dow(m.tt, 2)]>>, <<Padl(Day(m.tt),2,'0')>> <<laMonths[Month(m.tt)]>> <<Str(Year(m.tt),4)>> <<m.lcTime>>");
	+ iif(m.tlGMT, " GMT", iif(m.lnOffset > 0," -"," +");
	+ padl(transform(abs(m.lnOffset)), 2, "0") + "00")

return m.lcResult
