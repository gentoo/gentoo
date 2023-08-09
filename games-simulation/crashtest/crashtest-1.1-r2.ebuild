# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Educational car crash simulator"
HOMEPAGE="https://www.stolk.org/crashtest/"
SRC_URI="https://www.stolk.org/crashtest/${P}.tar.gz"
S="${WORKDIR}/${P}/src-${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-games/ode:=
	media-libs/freeglut
	media-libs/plib
	virtual/glu
	virtual/opengl
	x11-libs/fltk:1[opengl]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_prepare() {
	default

	sed -e "s|@GENTOO_DATADIR@|${EPREFIX}/usr/share/${PN}|" \
		-e "s|@GENTOO_BINDIR@|${EPREFIX}/usr/bin|" \
		-i Makefile ${PN}.cxx || die

	tc-export CXX
}

src_install() {
	default

	make_desktop_entry ${PN} Crashtest applications-games
}
