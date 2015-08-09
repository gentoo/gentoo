# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

MY_P=wmMand-${PV}

DESCRIPTION="a dockable mandelbrot browser"
HOMEPAGE="http://ciotog.homelinux.net/software/wmMand/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"

S=${WORKDIR}/${MY_P}/wmMand

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		SYSTEM="${LDFLAGS}" \
		INCDIR="" LIBDIR="" || die "emake failed."
}

src_install() {
	dobin wmMand || die "dobin failed."
	doman wmMand.6.gz
	doicon wmMand.png
	dodoc ../{BUGS,changelog,TODO}
}
