# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="OpenStack Cinder brick library for managing local volume attaches"
HOMEPAGE="https://github.com/openstack/cinder"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE=""

CDEPEND=">=dev-python/pbr-1.8[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	>=dev-python/eventlet-0.18.4[${PYTHON_USEDEP}]
	>=dev-python/oslo-concurrency-3.8.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.11.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-serialization-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-privsep-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-service-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.18.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.10.0[${PYTHON_USEDEP}]
	!~dev-python/requests-2.12.2[${PYTHON_USEDEP}]
	>=dev-python/retrying-1.2.3[${PYTHON_USEDEP}]
	!~dev-python/retrying-1.3.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/os-win-1.4.0[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i '/^hacking/d' test-requirements.txt || die
	distutils-r1_python_prepare_all
}
