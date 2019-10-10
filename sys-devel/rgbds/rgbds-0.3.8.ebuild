# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Rednex Game Boy Development System"
HOMEPAGE="https://rednex.github.io/rgbds/"
SRC_URI="https://github.com/rednex/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libpng:0=
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
"

src_prepare() {
	default
	sed -i -e 's/--static//g' Makefile || die
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		Q= \
		VERSION_STRING=${PV} || die
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX=/usr \
		Q= \
		STRIP= \
		mandir=/usr/share/man \
		install || die
}
