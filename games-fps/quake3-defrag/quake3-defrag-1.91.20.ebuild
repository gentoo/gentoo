# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-defrag/quake3-defrag-1.91.20.ebuild,v 1.3 2012/01/26 15:50:49 ago Exp $

EAPI=2

MOD_DESC="Trickjumping challenges for Quake III"
MOD_NAME="Defrag"
MOD_DIR="defrag"

inherit games games-mods

HOMEPAGE="http://cggdev.org/"
SRC_URI="http://q3defrag.org/files/defrag/defrag_${PV}.zip
	http://www.german-defrag.de/files/defrag/defragcpmpak01.zip
	http://www.german-defrag.de/files/defrag/df-extras002.zip
	http://www.german-defrag.de/files/defrag/defragpak1.zip
	http://www.german-defrag.de/files/defrag/defragpak2.zip
	http://www.german-defrag.de/files/defrag/defragpak3.zip
	http://www.german-defrag.de/files/defrag/defragpak4.zip
	http://www.german-defrag.de/files/defrag/defragpak5.zip
	http://www.german-defrag.de/files/defrag/defragpak7.zip
	http://www.german-defrag.de/files/defrag/defragpak8.zip
	http://www.german-defrag.de/files/defrag/defragpak9.zip
	http://www.german-defrag.de/files/defrag/defragpak10.zip
	http://www.german-defrag.de/files/defrag/defragpak11.zip"

LICENSE="freedist"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"

src_unpack() {
	unpack defrag_${PV}.zip
	cd ${MOD_DIR}
	unpack defragpak{1,2,3,4,5,7,8,9,10,11}.zip
	unpack defragcpmpak01.zip
	unpack df-extras002.zip
}

src_prepare() {
	cd ${MOD_DIR}
	mv -f DeFRaG/* . || die
	rm -rf DeFRaG
	mv -f *.txt docs/ || die
	rm -rf misc/{mirc-script,misc,tools}
}
