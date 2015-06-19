# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom3-lms/doom3-lms-4.ebuild,v 1.3 2013/04/29 16:21:08 ulm Exp $

EAPI=2

MOD_DESC="add co-op support and/or play against swarms of monsters"
MOD_NAME="Last Man Standing"
MOD_DIR="lms4"

inherit games games-mods

HOMEPAGE="http://doom3coop.com/"
SRC_URI="LastManStandingCoop4Multiplatform.zip"

LICENSE="GameFront"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch bindist"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "http://www.filefront.com/9934113"
	elog "and move it to ${DISTDIR}"
}

src_prepare() {
	cd ${MOD_DIR} || die
	rm -f *.{bat,url} game_lms40{0,2}.pk4
}
