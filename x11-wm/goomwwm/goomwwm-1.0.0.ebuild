# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="Get out of my way, Window Manager!"
HOMEPAGE="http://aerosuidae.net/goomwwm/"
SRC_URI="http://aerosuidae.net/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	x11-libs/libXft
	x11-libs/libX11
	x11-libs/libXinerama
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_prepare() {
	sed -i -e 's|$(LDADD) $(LDFLAGS)|$(LDFLAGS) $(LDADD)|g' Makefile || die
}

src_configure() {
	use debug && append-cflags -DDEBUG
}

src_compile() {
	emake CC=$(tc-getCC) proto normal
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
