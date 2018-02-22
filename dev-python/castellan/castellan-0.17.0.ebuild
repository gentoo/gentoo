# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

DESCRIPTION="Generic Key Manager interface for OpenStack"
HOMEPAGE="https://pypi.python.org/pypi/castellan"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/Babel-2.3.4[${PYTHON_USEDEP}]
	!~dev-python/Babel-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.9[${PYTHON_USEDEP}]
	!~dev-python/cryptography-2.0[${PYTHON_USEDEP}]
	>=dev-python/python-barbicanclient-4.0.0[${PYTHON_USEDEP}]
	!~dev-python/python-barbicanclient-4.5.0[${PYTHON_USEDEP}]
	!~dev-python/python-barbicanclient-4.5.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-5.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-context-2.19.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-3.30.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-1.20.0[${PYTHON_USEDEP}]
	>=dev-python/keystoneauth-3.3.0[${PYTHON_USEDEP}]
"
