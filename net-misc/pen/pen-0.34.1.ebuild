# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="TCP Load Balancing Port Forwarder"
HOMEPAGE="http://siag.nu/pen/"
SRC_URI="http://siag.nu/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="geoip ssl"

RDEPEND="
	geoip? ( dev-libs/geoip )
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="${RDEPEND}"

src_configure() {
	econf --with-docdir=/usr/share/doc/${PF} \
		$(use_with geoip) \
		$(use_with ssl)
}
