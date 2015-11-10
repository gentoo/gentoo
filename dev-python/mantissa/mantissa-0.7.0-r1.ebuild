# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

DESCRIPTION="An extensible, multi-protocol, multi-user, interactive application server"
HOMEPAGE="http://divmod.org/trac/wiki/DivmodMantissa https://pypi.python.org/pypi/Mantissa"
SRC_URI="mirror://pypi/${TWISTED_PN:0:1}/${TWISTED_PN}/${TWISTED_P}.tar.gz"

KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-python/axiom-0.6.0-r1[${PYTHON_USEDEP}]
	>=dev-python/cssutils-0.9.10-r1[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	>=dev-python/nevow-0.10.0-r1[${PYTHON_USEDEP}]
	>=dev-python/pytz-2012j[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP}]
	dev-python/twisted-mail[${PYTHON_USEDEP}]
	>=dev-python/vertex-0.3.0-r1[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

TWISTED_PLUGINS=( axiom.plugins nevow.plugins xmantissa.plugins )

python_install() {
	distutils-r1_python_install

	# remove foreign caches we don't want to own
	find "${D}$(python_get_sitedir)" -name 'dropin.cache' -delete || die
	# then our own one
	touch "${D}$(python_get_sitedir)"/xmantissa/plugins/dropin.cache || die
}

python_install_all() {
	dodoc NAME.txt NEWS.txt

	distutils-r1_python_install_all
}

python_test() {
	trial xmantissa || die "tests failed with ${EPYTHON}"
}
