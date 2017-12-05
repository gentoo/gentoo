# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="This is a client for the OpenStack Sahara API, aka HADOOP"
HOMEPAGE="https://github.com/openstack/python-saharaclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

CDEPEND=">=dev-python/pbr-1.8.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}
	test? (
		>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/oslo-sphinx-4.7.0[${PYTHON_USEDEP}]
		>=dev-python/oslotest-1.10.0[${PYTHON_USEDEP}]
		>=dev-python/os-testr-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/reno-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.2.1[${PYTHON_USEDEP}]
		<dev-python/sphinx-1.4[${PYTHON_USEDEP}]
		>=dev-python/testrepository-0.0.18[${PYTHON_USEDEP}]
	)"
RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-2.18.0[${PYTHON_USEDEP}]
	>=dev-python/osc-lib-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.18.0[${PYTHON_USEDEP}]
	>=dev-python/python-openstackclient-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.12.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}

python_test() {
	testr init
	testr run --parallel || die "testsuite failed under python2.7"
}
