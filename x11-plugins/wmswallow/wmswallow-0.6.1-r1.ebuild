# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="A dock applet to make any application dockable"
HOMEPAGE="https://www.dockapps.net/wmswallow"
SRC_URI="https://www.dockapps.net/download/${PN}.tar.Z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

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
