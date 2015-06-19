# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/ut2004-crossfire/ut2004-crossfire-1.95.ebuild,v 1.1 2010/04/18 05:10:17 mr_bones_ Exp $

EAPI=2

MOD_NAME="Crossfire"
MOD_DESC="Special Forces vs Terrorists"
MOD_DIR="TOCrossfire"
MOD_ICON="Help/icons/TOC_TERROR2.png"

inherit games games-mods

HOMEPAGE="http://www.to-crossfire.net/"
SRC_URI="ftp://to-crossfire.speicherland.com/TOC/client/TOCrossfire_beta_${PV}_full.zip
	http://www.to-crossfire.org/mirrors/client/TOCrossfire_beta_${PV}_full.zip"

# See Help/EULA.txt
LICENSE="free-noncomm"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"

src_unpack() {
	unpack ${A}
	unpack ./TOCinstall.tgz
}

src_prepare() {
	rm -f *.{exe,reg,sh,tgz,txt}
	rm -rf TOCInstaller.app stuff
	cd ${MOD_DIR} || die
	rm -f *.{bat,exe} Help/*.{exe,zip}
}
