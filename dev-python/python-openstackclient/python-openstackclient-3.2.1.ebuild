# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack APIs"
HOMEPAGE="https://github.com/openstack/python-openstackclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
		>=dev-python/fixtures-3.0.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
		!~dev-python/oslo-sphinx-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]
		>=dev-python/os-client-config-1.13.1[${PYTHON_USEDEP}]
		!~dev-python/os-client-config-1.19.0[${PYTHON_USEDEP}]
		!~dev-python/os-client-config-1.19.1[${PYTHON_USEDEP}]
		!~dev-python/os-client-config-1.20.0[${PYTHON_USEDEP}]
		!~dev-python/os-client-config-1.20.1[${PYTHON_USEDEP}]
		!~dev-python/os-client-config-1.21.0[${PYTHON_USEDEP}]
		>=dev-python/os-testr-0.7.0[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/osprofiler-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/bandit-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/wrapt-1.7.0[${PYTHON_USEDEP}]
	)"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/cliff-1.15.0[${PYTHON_USEDEP}]
	!~dev-python/cliff-1.16.0[${PYTHON_USEDEP}]
	!~dev-python/cliff-1.17.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-0.9.4[${PYTHON_USEDEP}]
	>=dev-python/osc-lib-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/python-glanceclient-2.3.0[${PYTHON_USEDEP}]
	!~dev-python/python-glanceclient-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/python-keystoneclient-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-2.29.0[${PYTHON_USEDEP}]
	!~dev-python/python-novaclient-2.33.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-1.6.1[${PYTHON_USEDEP}]
	!~dev-python/python-cinderclient-1.7.0[${PYTHON_USEDEP}]
	!~dev-python/python-cinderclient-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.8.1[${PYTHON_USEDEP}]
	!~dev-python/requests-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.5.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	# clients aren't actually needed
	sed -i '/client\>/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	testr init
	testr run || die "testsuite failed under python2.7"
}

python_install_all() {
	distutils-r1_python_install_all
}
