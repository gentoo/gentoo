# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A middleware for the OpenStack Keystone API"
HOMEPAGE="https://github.com/openstack/keystonemiddleware"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pycrypto-2.6[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		!~dev-python/oslo-sphinx-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
		!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testresources-0.2.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/python-memcached-1.56[${PYTHON_USEDEP}]
		>=dev-python/bandit-1.1.0[${PYTHON_USEDEP}]
	)"

RDEPEND="
	${CDEPEND}
	>=dev-python/keystoneauth-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-3.14.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/positional-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pycadf-1.1.0[${PYTHON_USEDEP}]
	!~dev-python/pycadf-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/python-keystoneclient-2.1.0[${PYTHON_USEDEP}]
	<dev-python/python-keystoneclient-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]"

PATCHES=(
)

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	testr init
	testr run || die "testsuite failed under python2.7"
	flake8 ${PN/python-/}/tests || die "run over tests folder by flake8 drew error"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	use examples && local EXAMPLES=( examples/.)
	distutils-r1_python_install_all
}
