# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/enemy-territory-truecombat/enemy-territory-truecombat-0.49b.ebuild,v 1.7 2014/09/07 15:29:26 ulm Exp $

EAPI=2

GAME="enemy-territory"
MOD_DESC="a team-based realism modification"
MOD_NAME="True Combat"
MOD_DIR="tcetest"
MOD_ICON="tce_icon_pc.ico"

inherit games games-mods

MY_PV=${PV/.}
HOMEPAGE="http://truecombat.com/"
SRC_URI="http://dragons-perch.net/tce/tcetest049.zip
	http://freeserver.name/files/installer/linux/tcetest049.zip
	http://mirror.rosvosektori.net/tcetest049.zip
	http://dragons-perch.net/tce/tce${MY_PV}_all_os_fixed.zip"

LICENSE="freedist"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"

RDEPEND="~virtual/libstdc++-3.3"

QA_PREBUILT="${INS_DIR:1}/${MOD_DIR}/*.so"

src_unpack() {
	unpack tcetest049.zip
	cd ${MOD_DIR} || die
	unpack tce${MY_PV}_all_os_fixed.zip
}

src_prepare() {
	rm -rf ${MOD_DIR}/Mac*
}
