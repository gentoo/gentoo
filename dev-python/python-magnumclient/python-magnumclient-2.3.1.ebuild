# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="A client for the OpenStack Magnum API"
HOMEPAGE="https://github.com/openstack/python-magnumclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"

CDEPEND=">=dev-python/pbr-1.6[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.16.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.16.0[${PYTHON_USEDEP}]
	>=dev-python/os-client-config-1.13.1[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.19.0[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.19.1[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.20.0[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.20.1[${PYTHON_USEDEP}]
	!~dev-python/os-client-config-1.21.0[${PYTHON_USEDEP}]
	>=dev-python/prettytable-0.7[${PYTHON_USEDEP}]
	<dev-python/prettytable-0.8[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.0.0[${PYTHON_USEDEP}]
	!~dev-python/cryptography-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/decorator-3.4.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	# built in...
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
