# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pycadf/pycadf-0.8.0.ebuild,v 1.3 2015/07/07 16:35:31 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="python implementation of DMTF Cloud Audit (CADF) data model"
HOMEPAGE="https://pypi.python.org/pypi/pycadf"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	test? (
		>=dev-python/hacking-0.10[${PYTHON_USEDEP}]
		<dev-python/hacking-0.11[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
		>=dev-python/mock-1.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-messaging-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/subunit-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
		!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.2.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/oslo-sphinx[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		dev-python/sphinxcontrib-httpdomain[${PYTHON_USEDEP}]
	)"
# !=1.2.0 of sphinx deleted since it is not in portage anyway
RDEPEND=">=dev-python/Babel-1.3[${PYTHON_USEDEP}]
		>=dev-python/oslo-config-1.6.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-context-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-i18n-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-serialization-1.2.0[${PYTHON_USEDEP}]
		>=dev-python/pytz-2013d[${PYTHON_USEDEP}]
		>=dev-python/six-1.7.0[${PYTHON_USEDEP}]
		>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/pytz-2013.6[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	nosetests ${PN}/tests || die "test failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
