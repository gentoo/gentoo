# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/tiny-and-big/tiny-and-big-1.4.1.ebuild,v 1.3 2015/02/10 10:16:55 ago Exp $

# TODO: unbundle media-libs/cal3d, lib hacked or old version

EAPI=5

inherit eutils games

DESCRIPTION="Combines elements of adventure, jump&run and physical puzzles"
HOMEPAGE="http://www.tinyandbig.com/"
SRC_URI="tinyandbig_grandpasleftovers-retail-linux-${PV}_1370968537.tar.bz2"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="bundled-libs"
RESTRICT="bindist fetch bundled-libs? ( splitdebug )"

MYGAMEDIR=${GAMES_PREFIX_OPT}/${PN}
QA_PREBUILT="${MYGAMEDIR#/}/bin32/*
	${MYGAMEDIR#/}/bin64/*"

DEPEND="app-arch/bzip2"
RDEPEND="
	virtual/opengl
	media-libs/openal
	x11-libs/libX11
	!bundled-libs? (
		media-gfx/nvidia-cg-toolkit
	)"

S=${WORKDIR}/tinyandbig

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_prepare() {
	if use !bundled-libs ; then
		rm -v $(usex amd64 "bin64" "bin32")/libCg{,GL}.so || die "unbundling libs failed!"
	fi
}

src_install() {
	local bindir=$(usex amd64 "bin64" "bin32")

	insinto "${MYGAMEDIR}"
	doins -r assets ${bindir}

	games_make_wrapper ${PN} "./${bindir}/tinyandbig" "${MYGAMEDIR}" "${MYGAMEDIR}/${bindir}"
	make_desktop_entry ${PN} "Tiny & Big"
	dodoc readme.txt

	fperms +x "${MYGAMEDIR}"/${bindir}/tinyandbig
	prepgamesdirs
}
