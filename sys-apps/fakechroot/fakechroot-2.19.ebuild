# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="Provide a faked chroot environment without requiring root privileges"
HOMEPAGE="http://fakechroot.alioth.debian.org/"
SRC_URI="mirror://debian/pool/main/f/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RESTRICT="test"

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc NEWS.md README.md
	find "${D}" -name '*.la' -exec rm -f '{}' +
}
