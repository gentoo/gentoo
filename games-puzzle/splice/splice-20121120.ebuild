# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: unbundle mono? (seems hardcoded)
#       icon

EAPI=5

inherit eutils games

DESCRIPTION="An experimental and artistic puzzler set in a microbial world"
HOMEPAGE="http://www.cipherprime.com/games/splice/"
SRC_URI="splice-linux-1353389454.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="bindist fetch splitdebug"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/Splice*
	${MYGAMEDIR#/}/Splice_Data/Mono/*"

RDEPEND="
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext"

S=${WORKDIR}/Linux

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
}

src_prepare() {
	einfo "removing ${ARCH} unrelated files..."
	rm -v Splice.x86$(usex amd64 "" "_64") || die
	rm -rv Splice_Data/Mono/x86$(usex amd64 "" "_64") || die

	rm README~ || die
	mv README "${T}"/ || die
}

src_install() {
	dodoc "${T}"/README

	insinto "${MYGAMEDIR}"
	doins -r *

	make_desktop_entry ${PN}
	games_make_wrapper ${PN} "./Splice.x86$(usex amd64 "_64" "")" "${MYGAMEDIR}"

	fperms +x "${MYGAMEDIR}"/Splice.x86$(usex amd64 "_64" "")
	prepgamesdirs
}
