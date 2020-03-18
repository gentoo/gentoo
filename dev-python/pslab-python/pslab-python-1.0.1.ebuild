# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Python library for communicating with Pocket Science Lab"
HOMEPAGE="https://pslab.io"
SRC_URI="https://github.com/fossasia/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="${PYTHON_DEPS}
	dev-python/numpy
	dev-python/pyqtgraph
	dev-python/pyserial
	sci-libs/scipy"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"
BDEPEND="dev-python/setuptools"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.1-sys_version.patch
	"${FILESDIR}"/${PN}-1.0.1-no_install_udev_rules.patch
)

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_install_all() {
	use doc && HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )
	distutils-r1_python_install_all
}
