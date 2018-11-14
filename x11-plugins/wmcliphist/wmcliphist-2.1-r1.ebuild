# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Dockable clipboard history application for Window Maker"
HOMEPAGE="https://www.dockapps.net/wmcliphist"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/dockapps

src_prepare() {
	sed -e '/^PREFIX/s:=.*:=/usr:' \
		-i Makefile || die
	tc-export CC
}

src_install() {
	default

	dodoc ChangeLog README
	newdoc ${PN}rc ${PN}rc.sample
}
