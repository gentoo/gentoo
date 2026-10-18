# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

SEC_KEYS_VALIDPGPKEYS=(
	# Rodent of Unusual Size (DSA) <coar@ACM.Org>
	'DE29FB3971E71543FD2DC049508EAEC5302DA568:coar.dsa:manual,ubuntu'
	# Rodent of Unusual Size <coar@ACM.Org>
	'13155B0E9E634F42BF6C163FDDBA64BA2C312D2F:coar:manual,ubuntu,ubuntu'
	# Jim Jagielski <jim@apache.org>
	'8B39757B1D8A994DF2433ED58B3A601F08C975E5:jim:manual,ubuntu'
	# Jim Jagielski (Release Signing Key) <jim@apache.org>
	'A93D62ECC3C8EA12DB220EC934EA76E6791485A8:jim.release:manual,ubuntu'
	# Dean Gaudet <dgaudet@apache.org>
	'31EE1A81B8D066548156D37B7D6DBFD1F08E012A:dgaudet:manual,ubuntu'
	# William A. Rowe, Jr. <wrowe@rowe-clan.net>
	'B1B96F45DFBDCCF974019235193F180AB55D9977:wrowe:manual,ubuntu'
	# Cliff Woolley <jwoolley@apache.org>
	'A10208FEC3152DD7C0C9B59B361522D782AB7BD1:jwoolley:manual,ubuntu'
	# Cliff Woolley <jwoolley@virginia.edu>
	'3DE024AFDA7A4B15CB6C14410F81AA8AB0D5F771:jwoolley2:manual,ubuntu'
	# Graham Leggett <minfrin@apache.org>
	'EB138C6AF0FC691001B16D93344A844D751D7F27:minfrin:manual,ubuntu'
	# Greg Ames <gregames@apache.org>
	'FA51765D3CE4EB83BFE1BDB7605E165A6D791A41:gregames:manual,ubuntu'
	# Roy T. Fielding <fielding@gbiv.com>
	'CBA5A7C21EC143314C41393E5B968010E04F9A89:fielding:manual,ubuntu'
	# Justin R. Erenkrantz <jerenkrantz@apache.org>
	'3C016F2B764621BB549C66B516A96495E2226795:jerenkrantz:manual,ubuntu'
	# Ian Holsman <ianh@apache.org>
	'67D4D4C479EDD9EC88E1734CAB7A60BC2CF86427:ianh:manual,ubuntu'
	# Aaron Bannert <abannert@kuci.org>
	'937FB3994A242BA9BF49E93021454AF0CC8B0F7E:abannert:manual,ubuntu,openpgp'
	# Brad Nicholes <bnicholes@novell.com>
	'EAD1359A4C0F2D37472AAF28F55DF0293A4E7AC9:bnicholes:manual,ubuntu'
	# Sander Striker <striker@apache.org>
	'4C1EADADB4EF5007579C919C6635B6C0DE885DD3:striker:manual,ubuntu'
	# Greg Stein <gstein@lyra.org>
	'01E475360FCCF1D0F24B9D145D414AE1E005C9CB:gstein:manual,ubuntu'
	# Andre Malo <nd@apache.org>
	'92CCEF0AA7DD46AC3A0F498BCA6939748103A37E:nd:manual,ubuntu,openpgp'
	# Erik Abele <erik@codefaktor.de>
	'D395C7573A68B9796D38C258153FA0CD75A67692:erik:manual,ubuntu'
	# Astrid Kessler (Kess) <kess@kess-net.de>
	'FA39B617B61493FD283503E7EED1EA392261D073:kess:manual,ubuntu'
	# Joe Schaefer <joe@sunstarsys.com>
	'984FB3350C1D5C7A3282255BB31B213D208F5064:joe:manual,ubuntu'
	# Gregory Trubetskoy (Grisha) <grisha@ispol.com>
	'F8C2405F8893395E4DA868BAA01DBC9EA879FCF5:grisha:manual,ubuntu'
	# Stas Bekman <stas@stason.org>
	'FE7A49DAA875E890B4167F76CCB2EB46E76CF6D0:stas:manual,ubuntu'
	# Paul Querna <chip@force-elite.com>
	'39F6691A0ECF0C50E8BB849CF78875F642721F00:chip:manual,ubuntu'
	# Colm MacCarthaigh <colm.maccarthaigh@heanet.ie>
	'29A2BA848177B73878277FA475CAA2A3F39B3750:colm.maccarthaigh:manual,ubuntu'
	# Ruediger Pluem <rpluem@apache.org>
	'120A8667241AEDD4A78B46104C042818311A3DE5:rpluem:manual,ubuntu'
	# Maxime Petazzoni (Bulix.org) <maxime.petazzoni@bulix.org>
	'D694DAB98F4E68A84C17F011ECAB0E7B83E6AE0D:maxime.petazzoni:manual,ubuntu'
	# Nick Kew <nick@webthing.com>
	'453510BDA6C5855624E009236D0BC73A40581837:nick:manual,ubuntu'
	# Sander Temme <sander@temme.net>
	'FC5A6FC62E252DFD8007EE239BB863B0F51BB88A:sander:manual,ubuntu'
	# Philip M. Gollucci <pgollucci@p6m7g8.com>
	'0DE5C55C6BF3B2352DABB89E13249B4FEC88A0BF:pgollucci:manual,ubuntu'
	# Bojan Smojver <bojan@rexursive.com>
	'7CDBED100806552182F98844E8E7E00B4DAA1988:bojan:manual,ubuntu'
	# Issac Goldstand <margol@beamartyr.net>
	'A8BA9617EF3BCCAC3B29B869EDB105896F9522D8:margol:manual,ubuntu'
	# "Guenter Knauf" ("CODE SIGNING KEY") <fuankg@apache.org>
	'3E6AC004854F3A7F03566B592FF06894E55B0D0E:fuankg:manual,ubuntu'
	# Jeff Trawick (CODE SIGNING KEY) <trawick@apache.org>
	'5B5181C2C0AB13E59DA3F7A3EC582EB639FF092C:trawick:manual,ubuntu'
	# Eric Covener <covener@apache.org>
	'65B2D44FE74BD5E3DE3AC3F082781DE46D5954FA:covener:manual,ubuntu'
	# Yann Ylavic <ylavic@apache.org>
	'8935926745E1CE7E3ED748F6EC99EE267EB5F61A:ylavic:manual,ubuntu'
	# Daniel Ruggeri (http\x3a//home.apache.org/~druggeri/) <druggeri@apache.org>
	'B9E8213AEFB861AF35A41F2C995E35221AD84DFF:druggeri:manual,ubuntu'
	# Daniel Ruggeri (http\x3a//home.apache.org/~druggeri/) <druggeri@apache.org>
	'E3480043595621FE56105F112AB12A7ADC55C003:druggeri2:manual,ubuntu'
	# Joe Orton (Release Signing Key) <jorton@apache.org>
	'93525CFCF6FDFFB3FD9700DD5A4B10AE43B56A27:jorton:manual,ubuntu'
	# Christophe JAILLET <christophe.jaillet@wanadoo.fr>
	'C55AB7B9139EB2263CD1AABC19B033D1760C227B:christophe.jaillet:manual,ubuntu'
	# Stefan Eissing (icing) <stefan@eissing.org>
	'26F51EF9A82F4ACB43F1903ED377C9E7D1944C66:stefan:manual,ubuntu'
)

inherit sec-keys

DESCRIPTION="OpenPGP keys used to sign Apache httpd"
HOMEPAGE="https://httpd.apache.org/dev/verification.html"
SRC_URI+=" https://downloads.apache.org/httpd/KEYS -> ${P}"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
