# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack APIs"
HOMEPAGE="https://github.com/openstack/python-openstackclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"
REQUIRED_USE="test? ( doc )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		test? (
			>=dev-python/hacking-0.10.0[${PYTHON_USEDEP}]
			<dev-python/hacking-0.11[${PYTHON_USEDEP}]
			>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			>=dev-python/fixtures-0.3.14[${PYTHON_USEDEP}]
			>=dev-python/mock-1.0[${PYTHON_USEDEP}]
			>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
			<dev-python/oslo-sphinx-2.6.0[${PYTHON_USEDEP}]
			>=dev-python/oslotest-1.5.1[${PYTHON_USEDEP}]
			<dev-python/oslotest-1.6.0[${PYTHON_USEDEP}]
			>=dev-python/requests-mock-0.6.0[${PYTHON_USEDEP}]
			>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
			>=dev-python/testtools-0.9.36[${PYTHON_USEDEP}]
			!~dev-python/testtools-1.2.0[${PYTHON_USEDEP}]
			>=dev-python/webob-1.2.3[${PYTHON_USEDEP}]
		)
		doc? (
			>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
			<dev-python/oslo-sphinx-2.6.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
			<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
		)
	"
RDEPEND="
	>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
	<dev-python/pbr-1.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-1.3[${PYTHON_USEDEP}]
	>=dev-python/cliff-1.10.0[${PYTHON_USEDEP}]
	<dev-python/cliff-1.11.0[${PYTHON_USEDEP}]
	>=dev-python/cliff-tablib-1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-1.9.3[${PYTHON_USEDEP}]
	<dev-python/oslo-config-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
	<dev-python/oslo-i18n-1.6.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-utils-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.4.0[${PYTHON_USEDEP}]
	<dev-python/oslo-serialization-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-0.15.0
	<dev-python/python-glanceclient-0.18.0
	>=dev-python/python-keystoneclient-1.1.0
	<dev-python/python-keystoneclient-1.4.0
	>=dev-python/python-novaclient-2.22.0
	<dev-python/python-novaclient-2.24.0
	>=dev-python/python-cinderclient-1.1.0
	<dev-python/python-cinderclient-1.2.0
	>=dev-python/python-neutronclient-2.3.11
	<dev-python/python-neutronclient-2.5.0
	>=dev-python/requests-2.5.2[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.3.0
	<dev-python/stevedore-1.4.0
"

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_test() {
	testr init
	testr run || die "testsuite failed under python2.7"
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/build/html/. )
	distutils-r1_python_install_all
}
