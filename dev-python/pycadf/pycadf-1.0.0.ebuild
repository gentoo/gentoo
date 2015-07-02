# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycadf/pycadf-1.0.0.ebuild,v 1.1 2015/07/02 10:17:41 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="python implementation of DMTF Cloud Audit (CADF) data model"
HOMEPAGE="https://pypi.python.org/pypi/pycadf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hacking-0.10[${PYTHON_USEDEP}]
		<dev-python/hacking-0.11[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-messaging-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
		!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/oslo-sphinx[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-httpdomain[${PYTHON_USEDEP}]
	)"
# !=1.2.0 of sphinx deleted since it is not in portage anyway
RDEPEND=">=dev-python/oslo-config-1.11.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/pytz-2013.6[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && "${PYTHON}" setup.py build_sphinx
}

python_test() {
	testr init || die "testr init failed under ${EPYTHON}"
	testr run || die "testr run failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
