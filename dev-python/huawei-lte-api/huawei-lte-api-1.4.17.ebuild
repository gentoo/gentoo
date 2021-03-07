# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="API For huawei LAN/WAN LTE Modems"
HOMEPAGE="https://github.com/Salamek/huawei-lte-api"
SRC_URI="https://github.com/Salamek/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/dicttoxml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]"

python_prepare_all() {
	# https://github.com/Salamek/huawei-lte-api/issues/86
	sed "s:'pytest-runner'::" -i setup.py || die

	distutils-r1_python_prepare_all
}

distutils_enable_tests pytest
