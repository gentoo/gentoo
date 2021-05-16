# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_7 python3_8 )

inherit distutils-r1

DESCRIPTION="OpenStack Cinder brick library for managing local volume attaches"
HOMEPAGE="https://github.com/openstack/cinder"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

DEPEND=">=dev-python/pbr-5.4.1[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/pbr-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.15.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.26.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.23.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.44.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.24.3.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-privsep-1.32.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-2.23.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-1.24.0[${PYTHON_USEDEP}]
	!~dev-python/oslo-service-1.28.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.34.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.14.2[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/tenacity-6.0.0[${PYTHON_USEDEP}]
	>=dev-python/os-win-3.0.0[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i -e 's/\tetc/\t\/etc/g' setup.cfg || die
	distutils-r1_python_prepare_all
}
