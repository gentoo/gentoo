# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Plotly Dash apps from within Jupyter environments"
HOMEPAGE="https://plotly.com/dash/"
SRC_URI="https://github.com/plotly/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/ansi2html[${PYTHON_USEDEP}]
	sci-visualization/dash[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/retrying[${PYTHON_USEDEP}]"
BDEPEND=""

src_install () {
	distutils-r1_src_install
	mv "${D}"/usr/etc "${D}"/ || die
}
