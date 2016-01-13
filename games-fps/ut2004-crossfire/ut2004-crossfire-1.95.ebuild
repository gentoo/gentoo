# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MOD_NAME="Crossfire"
MOD_DESC="Special Forces vs Terrorists"
MOD_DIR="TOCrossfire"
MOD_ICON="Help/icons/TOC_TERROR2.png"

inherit games games-mods

HOMEPAGE="http://to-crossfire.tnc-clan.de/"
SRC_URI="ftp://files.tnc-clan.de/TOCrossfire/client/TOCrossfire_beta_${PV}_full.zip"

# See Help/EULA.txt
LICENSE="free-noncomm"
KEYWORDS="~amd64 ~x86"
IUSE="dedicated opengl"

src_unpack() {
	unpack ${A}
	unpack ./TOCinstall.tgz
}

src_prepare() {
	rm -f *.{exe,reg,sh,tgz,txt} || die
	rm -rf TOCInstaller.app stuff || die
	cd ${MOD_DIR} || die
	rm -f *.{bat,exe} Help/*.{exe,zip} || die
}
