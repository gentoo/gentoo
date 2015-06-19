# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/geoip-python/geoip-python-1.2.8-r1.ebuild,v 1.6 2015/04/08 08:04:57 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="GeoIP-Python"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for GeoIP"
HOMEPAGE="http://www.maxmind.com/app/python"
SRC_URI="http://www.maxmind.com/download/geoip/api/python/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ia64 ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-libs/geoip-1.4.8"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( README ChangeLog test.py test_city.py test_org.py )

python_test() {
	if "${PYTHON}" -m test; then
		einfo "tests passed unde ${EPYTHON}"
	else
		die "tests failed under ${EPYTHON}"
	fi
}
