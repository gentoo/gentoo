# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Coreutils Viewer: show progress for cp, rm, dd, and so forth"
HOMEPAGE="https://github.com/Xfennec/progress"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default

	sed -i \
		-e '/CFLAGS/s:-g ::' \
		Makefile || die
	tc-export CC
}

src_install() {
	emake PREFIX="${ED}/usr" install
	dodoc README.md
}
