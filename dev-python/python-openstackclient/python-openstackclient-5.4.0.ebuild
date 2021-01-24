# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A client for the OpenStack APIs"
HOMEPAGE="https://github.com/openstack/python-openstackclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0"
DEPEND="${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/cliff-2.8.0[${PYTHON_USEDEP}]
	!~dev-python/cliff-2.9.0[${PYTHON_USEDEP}]
	>=dev-python/openstacksdk-0.48.0[${PYTHON_USEDEP}]
	>=dev-python/osc-lib-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/python-keystoneclient-3.22.0[${PYTHON_USEDEP}]
	>=dev-python/python-novaclient-15.1.0[${PYTHON_USEDEP}]
	>=dev-python/python-cinderclient-3.3.0[${PYTHON_USEDEP}]
	>=dev-python/stevedore-2.0.1[${PYTHON_USEDEP}]
"
