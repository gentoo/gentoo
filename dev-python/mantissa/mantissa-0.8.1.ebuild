# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/mantissa/mantissa-0.8.1.ebuild,v 1.1 2015/08/07 06:36:53 idella4 Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit twisted-r1

MY_PN="${PN/m/M}"
DESCRIPTION="An extensible, multi-protocol, multi-user, interactive application server"
HOMEPAGE="https://github.com/twisted/mantissa"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="test"

# https://github.com/twisted/mantissa/issues/27
# Source still missing a folder 'doc' that has required modules and
# the fail / error rate is far higher then in 0.8.0
RESTRICT="test"

RDEPEND="
	>=dev-python/pyopenssl-0.13[${PYTHON_USEDEP}]
	>=dev-python/axiom-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/cssutils-0.9.5[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	>=dev-python/nevow-0.9.5[${PYTHON_USEDEP}]
	>=dev-python/pytz-2012j[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-14.0.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-mail-14.0.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-conch-14.0.0[${PYTHON_USEDEP}]
	>=dev-python/vertex-0.2[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )"

TWISTED_PLUGINS=( axiom.plugins nevow.plugins xmantissa.plugins )

python_test() {
	# https://github.com/twisted/mantissa/issues/27

	trial xmantissa || die "tests failed with ${EPYTHON}"
}

python_install() {
	distutils-r1_python_install

	# remove foreign caches we don't want to own
	find "${D}$(python_get_sitedir)" -name 'dropin.cache' -delete || die
	# then our own one
	touch "${D}$(python_get_sitedir)"/xmantissa/plugins/dropin.cache || die
}
