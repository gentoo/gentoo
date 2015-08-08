# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="Gets current song from MPRIS-aware media players"
HOMEPAGE="http://m0n5t3r.info/work/pidgin-mpris/"
SRC_URI="http://m0n5t3r.info/stuff/pidgin-mpris//${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="net-im/pidgin[gtk]
	x11-libs/gtk+:2
	sys-apps/dbus"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake install DESTDIR="${D}" || die "Install failed"
	dodoc INSTALL README TODO
}
