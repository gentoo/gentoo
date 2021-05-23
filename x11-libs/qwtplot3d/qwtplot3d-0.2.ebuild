# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
DOCS_CONFIG_NAME="Doxyfile.doxygen"

inherit docs qmake-utils

DESCRIPTION="3D plotting library for Qt5"
HOMEPAGE="http://qwtplot3d.sourceforge.net/ https://github.com/SciDAVis/qwtplot3d/"
SRC_URI="https://github.com/SciDAVis/qwtplot3d/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE="doc examples"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	x11-libs/gl2ps
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-examples.patch"
	"${FILESDIR}/${PN}-doxygen.patch"
	"${FILESDIR}/${PN}-gcc44.patch"
	"${FILESDIR}/${PN}-qt-4.8.0.patch"
	"${FILESDIR}/${PN}-sys-gl2ps.patch"
)

src_prepare() {
	default
	cat >> ${PN}.pro <<-EOF
		target.path = "${EPREFIX}/usr/$(get_libdir)"
		headers.path = "${EPREFIX}/usr/include/${PN}"
		headers.files = \$\$HEADERS
		INSTALLS = target headers
	EOF
}

src_configure() {
	eqmake5
}

src_compile() {
	default
	docs_compile
}

src_install () {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	if use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
