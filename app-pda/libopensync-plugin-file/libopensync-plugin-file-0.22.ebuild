# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

DESCRIPTION="OpenSync File Plugin"
HOMEPAGE="http://www.opensync.org/"
SRC_URI="http://www.opensync.org/download/releases/${PV}/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="LGPL-2.1"
IUSE=""

RDEPEND="~app-pda/libopensync-${PV}
	dev-libs/glib:2
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	find "${D}" -name '*.la' -exec rm -f {} + || die
}
