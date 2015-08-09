# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils games

DESCRIPTION="Non-official map pack for Eternal Lands"
HOMEPAGE="http://maps.el-pl.org/"
SRC_URI="mirror://gentoo/${P}.zip"
LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"

KEYWORDS="~amd64 ~x86 ~x86-fbsd"

IUSE=""

DEPEND="games-rpg/eternal-lands-data[bloodsuckermaps]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insopts -m 0660
	insinto "${GAMES_DATADIR}/eternal-lands"
	doins -r maps || die "doins failed"

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	elog "Note that the Bloodsucker Maps are not official maps and are not"
	elog "supported by the Eternal Lands team."
	elog "Please do not bother Eternal Lands staff about bugs with the maps."
}
