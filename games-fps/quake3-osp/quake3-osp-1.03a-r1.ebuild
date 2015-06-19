# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-osp/quake3-osp-1.03a-r1.ebuild,v 1.6 2015/02/14 11:54:13 mgorny Exp $

EAPI=2

MOD_DESC="a tournament mod"
MOD_NAME="OSP"
MOD_DIR="osp"

inherit games games-mods

HOMEPAGE="http://www.orangesmoothie.org/"
SRC_URI="http://osp.dget.cc/orangesmoothie/downloads/osp-Quake3-${PV}_full.zip"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"

src_prepare() {
	cd ${MOD_DIR} || die
	rm -f VoodooStats-ReadMe.txt *.exe || die
	rm -rf voodoo || die
}
