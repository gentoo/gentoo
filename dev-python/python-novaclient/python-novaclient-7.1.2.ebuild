# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Nova API"
HOMEPAGE="https://github.com/openstack/python-novaclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/bandit-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/keyring-5.5.1[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-3.8.0[${PYTHON_USEDEP}]
		>=dev-python/python-cinderclient-1.6.0[${PYTHON_USEDEP}]
		!~dev-python/python-cinderclient-1.7.0[${PYTHON_USEDEP}]
		!~dev-python/python-cinderclient-1.7.1[${PYTHON_USEDEP}]
		>=dev-python/python-glanceclient-2.5.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.1[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.2.1[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.4[${PYTHON_USEDEP}]
		>=dev-python/os-client-config-1.22.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-4.7.0[${PYTHON_USEDEP}]
		>=dev-python/osprofiler-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testscenarios-0.4[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
	)"
RDEPEND="
	>=dev-python/keystoneauth-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/iso8601-0.1.11[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.18.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7.1[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.12.2[${PYTHON_USEDEP}]
	>=dev-python/simplejson-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]"

python_prepare_all() {
	# built in...
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	testr init
	testr run --parallel || die "testsuite failed under python2.7"
}
