# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

IUSE=""
DESCRIPTION="dockapp for monitoring filesystem usage"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/100"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}.linux-fs.patch
	sed -e "/^X11LIBS/s/-I$x_includes //" -i configure.in || die "sed failed"

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog
}
