# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmswallow/wmswallow-0.6.1-r1.ebuild,v 1.4 2015/04/19 09:45:10 ago Exp $

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A dock applet to make any application dockable"
HOMEPAGE="http://burse.uni-hamburg.de/~friedel/software/wmswallow.html"
SRC_URI="http://burse.uni-hamburg.de/~friedel/software/wmswallow/${PN}.tar.Z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/wmswallow

src_prepare() {
	epatch "${FILESDIR}"/${P}-format-security.patch
	sed -e "s:\${OBJS} -o:\${OBJS} \${LDFLAGS} -o:" \
		-e "/LIBS/s/-lXext/-lX11 \0/"\
		-i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" xfree
}

src_install() {
	dobin wmswallow
	dodoc CHANGELOG README todo
}
