# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/doom3-chextrek/doom3-chextrek-0.52.ebuild,v 1.5 2013/04/29 16:16:41 ulm Exp $

EAPI=2

MOD_DESC="Green slimeballs mod for kids"
MOD_NAME="Chex Trek: Beyond the Quest"
MOD_DIR="chextrek"
MOD_ICON="flem.ico"

inherit games-mods

HOMEPAGE="http://doom3.filefront.com/file/Chex_Trek_Beyond_the_Quest;82325"
SRC_URI="chextrek_beta_${PV/.}.zip"

LICENSE="GameFront"
KEYWORDS="amd64 x86"
IUSE="dedicated opengl"
RESTRICT="fetch bindist"

pkg_nofetch() {
	elog "Please download ${SRC_URI} from:"
	elog "http://www.filefront.com/8396958"
	elog "and move it to ${DISTDIR}"
}

src_prepare() {
	mv -f chextrek_beta* ${MOD_DIR} || die
}

pkg_postinst() {
	games-mods_pkg_postinst

	elog "Press 'E' to open doors in the game."
	elog "Press 'M' to toggle the map."
}
