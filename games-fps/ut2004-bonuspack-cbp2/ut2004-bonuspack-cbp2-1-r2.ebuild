# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MOD_DESC="Community Bonus Pack 2 volumes 1 and 2"
MOD_NAME="Community Bonus Pack 2 volumes 1 and 2"

inherit games games-mods

HOMEPAGE="http://liandri.beyondunreal.com/Unreal_Tournament_2004"
SRC_URI="https://ut.rushbase.net/beyondunreal/official/ut2004/cbp2-volume1_zip.zip
	https://ut.rushbase.net/beyondunreal/official/ut2004/cbp2-volume2_zip.zip"

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
