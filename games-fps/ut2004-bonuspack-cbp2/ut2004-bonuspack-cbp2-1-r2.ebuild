# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="Community Bonus Pack 2 volumes 1 and 2"
MOD_NAME="Community Bonus Pack 2 volumes 1 and 2"

inherit games games-mods

HOMEPAGE="http://www.planetunreal.com/cbp/"
SRC_URI="http://downloads.unrealadmin.org/UT2004/BonusPack/cbp2-volume1_zip.zip
	http://www.i4games.eu/downloads/ut2k4/cbp2-volume1_zip.zip
	http://downloads.unrealadmin.org/UT2004/BonusPack/cbp2-volume2_zip.zip
	http://www.i4games.eu/downloads/ut2k4/cbp2-volume2_zip.zip"

LICENSE="freedist"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="games-fps/ut2004-bonuspack-cbp1
	games-fps/ut2004-bonuspack-mega"

src_prepare() {
	# Provided by ut2004-bonuspack-cbp1
	rm Music/Soeren.ogg
	# Provided by ut2004-bonuspack-mega
	rm Textures/Ty_RocketTextures.utx

	cd Help
	# Useless orphan file
	rm Note.txt
	mv GERROIDREADME.txt DOM-CBP2-Gerroid.txt
	mv Readme.txt CBP2-Readme.txt
}
