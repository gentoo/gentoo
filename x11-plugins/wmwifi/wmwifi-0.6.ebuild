# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="wireless network interface monitor dockapp"
HOMEPAGE="http://www.dockapps.net/wmwifi"
SRC_URI="http://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

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
