# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmcpuload/wmcpuload-1.1.0_pre5.ebuild,v 1.8 2014/08/10 20:05:51 slyfox Exp $

DESCRIPTION="a dockapp for monitoring CPU usage with a LCD display"
HOMEPAGE="http://dockapps.windowmaker.org/file.php/id/36"
SRC_URI="mirror://gentoo/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-libs/libICE"

S=${WORKDIR}/${P/_/}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
