# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools systemd

DESCRIPTION="IPMI Management Utilities"
HOMEPAGE="http://ipmiutil.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-libs/openssl-1:0"
DEPEND="${RDEPEND}
	virtual/os-headers"

MAKEOPTS="${MAKEOPTS} -j1"

DOCS="AUTHORS ChangeLog NEWS README TODO doc/UserGuide"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf --disable-systemd --enable-sha256
}

src_install() {
	emake DESTDIR="${D}" sysdto="${D}/$(systemd_get_unitdir)" install
	rm -rf "${ED}"/etc/init.d # These are only for Fedora
}
