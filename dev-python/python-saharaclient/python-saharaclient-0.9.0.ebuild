# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="This is a client for the OpenStack Sahara API, aka HADOOP"
HOMEPAGE="https://github.com/openstack/python-saharaclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
		>=dev-python/pbr-0.8[${PYTHON_USEDEP}]
		<dev-python/pbr-1.0[${PYTHON_USEDEP}]
		test? (
			>=dev-python/hacking-0.10.0[${PYTHON_USEDEP}]
			<dev-python/hacking-0.11[${PYTHON_USEDEP}]
			>=dev-python/coverage-3.6[${PYTHON_USEDEP}]
			>=dev-python/mock-1.0[${PYTHON_USEDEP}]
			>=dev-python/oslo-config-1.9.3[${PYTHON_USEDEP}]
			>=dev-python/oslo-sphinx-2.5.0[${PYTHON_USEDEP}]
			>=dev-python/python-neutronclient-2.3.11[${PYTHON_USEDEP}]
			<dev-python/python-neutronclient-3[${PYTHON_USEDEP}]
			>=dev-python/python-novaclient-2.22.0[${PYTHON_USEDEP}]
			>=dev-python/python-swiftclient-2.2.0[${PYTHON_USEDEP}]
			>=dev-python/requests-mock-0.6.0[${PYTHON_USEDEP}]
			>=dev-python/sphinx-1.1.2[${PYTHON_USEDEP}]
			!~dev-python/sphinx-1.2.0[${PYTHON_USEDEP}]
			<dev-python/sphinx-1.3[${PYTHON_USEDEP}]
			>=dev-python/tempest-lib-0.4.0[${PYTHON_USEDEP}]
			>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
		)"
RDEPEND=">=dev-python/Babel-1.3[${PYTHON_USEDEP}]
		>=dev-python/netaddr-0.7.12[${PYTHON_USEDEP}]
		>=dev-python/oslo-i18n-1.5.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-utils-1.4.0[${PYTHON_USEDEP}]
		>=dev-python/python-keystoneclient-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
		!~dev-python/requests-2.4.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
		>=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
		<dev-python/prettytable-0.8[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i '/argparse/d' requirements.txt
	distutils-r1_python_prepare_all
}

python_test() {
	testr init
	testr run --parallel || die "testsuite failed under python2.7"
}
