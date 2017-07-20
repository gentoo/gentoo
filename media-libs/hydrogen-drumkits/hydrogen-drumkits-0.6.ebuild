# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="Free drumkits for Hydrogen"
HOMEPAGE="http://www.hydrogen-music.org"
for dk in ForzeeStereo Boss_DR-110 circAfriquev4 BJA_Pacific DeathMetal Millo_MultiLayered3 Millo_MultiLayered2 Millo-Drums_v.1 HardElectro1 ElectricEmpireKit Classic-626 Classic-808 K-27_Trash_Kit EasternHop-1 YamahaVintageKit ColomboAcousticDrumkit ErnysPercussion TR808909 Techno-1 TD-7kit Synthie-1 HipHop-2 HipHop-1 3355606kit VariBreaks; do
	SRC_URI="${SRC_URI} http://gentoostudio.org/src/hydrogen-drumkits/${dk}.h2drumkit"
done

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

S="${WORKDIR}"

src_unpack(){
	cp "${DISTDIR}"/*.h2drumkit "${S}"
}

src_install(){
	insinto  /usr/share/hydrogen/data/drumkits/
	doins -r *.h2drumkit
}
