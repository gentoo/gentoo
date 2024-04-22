# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Dockable clipboard history application for Window Maker"
HOMEPAGE="https://www.dockapps.net/wmcliphist"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"
S="${WORKDIR}/dockapps"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND="x11-libs/gtk+:3[X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -e '/^PREFIX/s:=.*:=/usr:' \
		-i Makefile || die
	tc-export CC
}

src_install() {
	default

	newdoc ${PN}rc ${PN}rc.sample
}
