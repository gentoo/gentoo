# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
DOCS_CONFIG_NAME="Doxyfile.doxygen"

inherit docs cmake

COMMIT="b2655743d30ed3185f3c0e2626b33a1d29655216"

DESCRIPTION="3D plotting library for Qt5"
HOMEPAGE="http://qwtplot3d.sourceforge.net/ https://github.com/SciDAVis/qwtplot3d/"
SRC_URI="https://github.com/SciDAVis/qwtplot3d/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="doc"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	x11-libs/gl2ps
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-doxygen.patch"
	"${FILESDIR}/${PN}-gcc44.patch"
	"${FILESDIR}/${P}-install-headers.patch"
)

src_compile() {
	cmake_src_compile
	docs_compile
}
