# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/avadon/avadon-1.0.4.ebuild,v 1.2 2013/08/18 00:20:16 hasufell Exp $

EAPI=5

inherit eutils unpacker games

DESCRIPTION="Epic fantasy role-playing adventure in an enormous and unique world"
HOMEPAGE="http://www.spiderwebsoftware.com/avadon/index.html"
SRC_URI="avadon-black-fortress_${PV}_all.run"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="fetch bindist"

QA_PREBUILT="${GAMES_PREFIX_OPT#/}/${PN}/Avadon*"

RDEPEND="media-libs/libsdl[X,opengl,video]
	media-libs/openal"
DEPEND="app-arch/unzip"

S=${WORKDIR}/data

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}
	local arch=$(usex amd64 "amd64" "x86")

	insinto "${dir}"
	doins -r "avadon files" icon.bmp

	exeinto "${dir}"
	doexe Avadon-${arch}

	newicon Avadon.png ${PN}.png
	games_make_wrapper ${PN} "./Avadon-${arch}" "${dir}"
	make_desktop_entry ${PN} "Avadon: The Black Fortress"

	dodoc README-linux.txt

	prepgamesdirs
}
