# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="TCP Load Balancing Port Forwarder"
HOMEPAGE="http://siag.nu/pen/"
SRC_URI="http://siag.nu/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="geoip ssl"

DEPEND="geoip? ( dev-libs/geoip )
	ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

src_configure() {
	econf --with-docdir=/usr/share/doc/${PF} \
		$(use_with geoip) \
		$(use_with ssl)
}
