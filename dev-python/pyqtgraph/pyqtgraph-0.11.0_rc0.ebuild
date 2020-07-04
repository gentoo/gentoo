# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

MY_PV=$(ver_rs 3 "")
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A pure-python graphics and GUI library built on PyQt and numpy"
HOMEPAGE="http://www.pyqtgraph.org/ https://pypi.org/project/pyqtgraph/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples opengl svg"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,widgets,opengl=,svg=,${PYTHON_USEDEP}]
	opengl? ( dev-python/pyopengl[${PYTHON_USEDEP}] )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.0-qt5_only.patch
)

DOCS=( CHANGELOG README.md )

S="${WORKDIR}"/${PN}-${MY_P}

distutils_enable_sphinx doc/source

python_prepare_all() {
	distutils-r1_python_prepare_all

	if ! use opengl; then
		rm -r pyqtgraph/opengl || die
	fi
}

python_install_all() {
	use examples && DOCS+=( examples/ )
	distutils-r1_python_install_all
}
