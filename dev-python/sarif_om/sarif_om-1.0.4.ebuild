# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Classes implementing the SARIF 2.1.0 object model"
HOMEPAGE="
	https://pypi.org/project/sarif-om/
	https://github.com/microsoft/sarif-python-om/"
SRC_URI="
	mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]"
