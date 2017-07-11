# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="Free drumkits for Hydrogen"
HOMEPAGE="http://www.hydrogen-music.org"
SRC_URI="http://gentoostudio.org/src/hydrogen-drumkits/ForzeeStereo.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/Boss_DR-110.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/circAfriquev4.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/BJA_Pacific.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/DeathMetal.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/Millo_MultiLayered3.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/Millo_MultiLayered2.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/Millo-Drums_v.1.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/HardElectro1.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/ElectricEmpireKit.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/Classic-626.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/Classic-808.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/K-27_Trash_Kit.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/EasternHop-1.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/YamahaVintageKit.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/ColomboAcousticDrumkit.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/ErnysPercussion.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/TR808909.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/Techno-1.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/TD-7kit.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/Synthie-1.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/HipHop-2.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/HipHop-1.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/3355606kit.h2drumkit
	http://gentoostudio.org/src/hydrogen-drumkits/VariBreaks.h2drumkit"

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

S="${WORKDIR}"

src_unpack(){
	cp "${DISTDIR}"/*.h2drumkit "${S}"
}

src_compile(){
	einfo "nothing to compile"
}

src_install(){
	insinto  /usr/share/hydrogen/data/drumkits/
	doins -r *.h2drumkit
}
