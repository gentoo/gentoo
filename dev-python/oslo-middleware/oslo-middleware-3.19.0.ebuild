# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="Components injected into wsgi pipelines to intercept request/response flows."
HOMEPAGE="https://pypi.python.org/pypi/oslo.middleware"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.middleware/oslo.middleware-${PV}.tar.gz"
S="${WORKDIR}/oslo.middleware-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

CDEPEND="
	>=dev-python/pbr-1.6[${PYTHON_USEDEP}]
	<dev-python/pbr-2.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		!~dev-python/oslo-sphinx-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
	)"
RDEPEND="
	${CDEPEND}
	>=dev-python/jinja-2.8[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-3.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/debtcollector-1.2.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests tests/ || die "test failed under ${EPYTHON}"
}
