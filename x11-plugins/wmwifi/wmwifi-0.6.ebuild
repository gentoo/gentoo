# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmwifi/wmwifi-0.6.ebuild,v 1.5 2010/12/02 15:46:06 flameeyes Exp $

IUSE=""
HOMEPAGE="http://wmwifi.digitalssg.net"
DESCRIPTION="wireless network interface monitor dockapp"
SRC_URI="http://digitalssg.net/debian/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto"

src_compile()
{
	econf || die "Configuration failed"

	# by default it does not honour our CFLAGS
	emake CFLAGS="${CFLAGS}" CPPFLAGS="${CFLAGS}" || die "Compilation failed"
}

src_install()
{
	dobin src/wmwifi || die
	doman wmwifi.1 || die
	dodoc AUTHORS README || die
}
