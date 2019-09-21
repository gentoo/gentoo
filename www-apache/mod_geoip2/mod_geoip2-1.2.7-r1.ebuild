# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit apache-module eutils

MY_P="${PN}_${PV}"
MY_PN="${PN/2}"

DESCRIPTION="geoip module gets the country and city a request originated from"
HOMEPAGE="http://www.maxmind.com/app/mod_geoip"
SRC_URI="http://geolite.maxmind.com/download/geoip/api/mod_geoip2/${MY_P}.tar.gz"
LICENSE="Apache-1.1"

KEYWORDS="~amd64 ~x86"
IUSE=""
SLOT="0"

DEPEND=">=dev-libs/geoip-1.4.8"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

# See apache-module.eclass for more information.
APACHE2_MOD_CONF="30_${PN}"
APACHE2_MOD_FILE="${S}/.libs/${MY_PN}.so"
APXS2_ARGS="-l GeoIP -c ${MY_PN}.c"
DOCFILES="INSTALL README README.php Changes"

need_apache2

src_unpack() {
	unpack ${A} && cd "${S}"
	epatch "${FILESDIR}/${P}-httpd24.patch"
}
