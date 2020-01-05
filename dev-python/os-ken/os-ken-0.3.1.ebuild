# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="OpenStack Cinder brick library for managing local volume attaches"
HOMEPAGE="https://github.com/openstack/os-ken"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/os-ken-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/eventlet-0.18.2[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.18.3[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.20.1[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.21.0[${PYTHON_USEDEP}]
	!~dev-python/eventlet-0.23.0[${PYTHON_USEDEP}]
	>=dev-python/msgpack-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/netaddr-0.7.18[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/ovs-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/routes-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/tinyrpc-0.6[${PYTHON_USEDEP}]
	>=dev-python/webob-1.2[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	sed -i '/^pbr/d' requirements.txt || die  # pbr should be uncapped in stable/ocata
	distutils-r1_python_prepare_all
}
