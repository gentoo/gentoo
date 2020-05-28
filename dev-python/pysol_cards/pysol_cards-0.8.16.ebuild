# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Deal PySol FreeCell cards"
HOMEPAGE="https://pypi.org/project/pysol-cards/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	dev-python/random2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
