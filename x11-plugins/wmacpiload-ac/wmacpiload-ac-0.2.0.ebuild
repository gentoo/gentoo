# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmacpiload-ac/wmacpiload-ac-0.2.0.ebuild,v 1.3 2014/08/10 20:03:54 slyfox Exp $

MY_P=${P/-ac}
DESCRIPTION="Hacked version of WMACPILoad, a dockapp to monitor CPU temp and battery time on ACPI kernels"
HOMEPAGE="http://wmacpiload.tuxfamily.org/"
SRC_URI="http://wmacpiload.tuxfamily.org/download/${MY_P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE="debug"

RDEPEND="x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

S="${WORKDIR}/${MY_P}"

src_compile() {
	econf $(use_enable debug)
	emake || die "compile failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
