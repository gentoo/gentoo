# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmping/wmping-0.2.1.ebuild,v 1.5 2014/08/10 20:08:49 slyfox Exp $

EAPI=5

DESCRIPTION="a simple host status monitoring dockapp"
HOMEPAGE="http://sourceforge.net/projects/wmping"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+suid"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
	x11-libs/libICE
	x11-libs/libXt"

src_install() {
	if use suid; then
		emake DESTDIR="${D}" install
	else
		dosbin ${PN}
	fi

	doman ${PN}.1
	dodoc AUTHORS CHANGES README
}

pkg_postinst() {
	use suid || ewarn "warning, ${PN} needs to be executed as root."
}
