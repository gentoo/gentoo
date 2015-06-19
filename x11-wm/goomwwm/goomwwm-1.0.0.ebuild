# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/goomwwm/goomwwm-1.0.0.ebuild,v 1.3 2013/11/02 17:27:04 jer Exp $

EAPI=5
inherit eutils toolchain-funcs

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
	x11-proto/xineramaproto
	x11-proto/xproto
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
