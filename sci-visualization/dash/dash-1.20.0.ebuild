# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Python framework for building ML & data science web apps"
HOMEPAGE="https://github.com/plotly/dash"
SRC_URI="https://github.com/plotly/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/future[${PYTHON_USEDEP}]
	sci-visualization/dash-table[${PYTHON_USEDEP}]
	sci-visualization/dash-html-components[${PYTHON_USEDEP}]
	sci-visualization/dash-core-components[${PYTHON_USEDEP}]
	dev-python/plotly[${PYTHON_USEDEP}]
	dev-python/flask-compress[${PYTHON_USEDEP}]"
BDEPEND=""

src_prepare() {
	distutils-r1_src_prepare
	cd dash-renderer
	distutils-r1_src_prepare
}

src_configure() {
	distutils-r1_src_configure
	cd dash-renderer
	distutils-r1_src_configure
}

src_compile() {
	distutils-r1_src_compile
	cd dash-renderer
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
	cd dash-renderer
	distutils-r1_src_install
}
