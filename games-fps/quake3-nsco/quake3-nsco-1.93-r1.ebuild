# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MOD_DESC="a US Navy Seals conversion mod"
MOD_NAME="Navy Seals: Covert Operations"
MOD_DIR="seals"

inherit games games-mods

HOMEPAGE="http://ns-co.net/"
SRC_URI="nsco_beta191a.zip
	nsco_beta193upd.zip"

LICENSE="freedist"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"
RESTRICT="strip mirror fetch"

src_unpack() {
	unpack nsco_beta19{1a,3upd}.zip
}

pkg_nofetch() {
	elog "Please goto ${HOMEPAGE}"
	elog "and download ${A} into ${DISTDIR}"
}
