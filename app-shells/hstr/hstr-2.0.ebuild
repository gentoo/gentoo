# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Shell history suggest box"
HOMEPAGE="https://github.com/dvorka/hstr http://www.mindforger.com"
SRC_URI="https://github.com/dvorka/hstr/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"

RDEPEND="
	sys-libs/ncurses:0=[unicode]"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig"

DOCS=( CONFIGURATION.md README.md )

PATCHES=( ${FILESDIR}/${P}-fix-ncurses-configure.patch )

src_prepare() {
	default
	sed \
		-e 's:-O2::g' \
		-i src/Makefile.am || die
	eautoreconf
}
