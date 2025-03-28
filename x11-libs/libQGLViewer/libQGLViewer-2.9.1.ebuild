# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake qmake-utils

DESCRIPTION="C++ library based on Qt that eases the creation of OpenGL 3D viewers"
HOMEPAGE="https://github.com/GillesDebunne/libQGLViewer"
SRC_URI="https://github.com/GillesDebunne/libQGLViewer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE="designer examples"

RDEPEND="
	dev-qt/qtbase:6[gui,opengl,widgets,xml]
	virtual/glu
	virtual/opengl
"
DEPEND="${RDEPEND}
	designer? ( dev-qt/qttools[designer] )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.1-fix_designer_plugin.patch
	"${FILESDIR}"/${PN}-2.9.1-rm_rpath.patch
)

src_prepare() {
	cmake_src_prepare

	# copy srcdir to use as docdir after
	if use examples; then
		cp -R "${S}"/examples "${S}"/examples-src || die
	fi
}

src_configure() {
	cmake_src_configure

	if use designer; then
		pushd designerPlugin || die
			eqmake6 designerPlugin.pro \
				LIB_NAME="QGLViewer" \
				LIBS="-L${BUILD_DIR}" \
				NO_QT_VERSION_SUFFIX="yes"
		popd || die
	fi

	if use examples; then
		pushd examples || die
			eqmake6 examples.pro \
				LIB_NAME="QGLViewer" \
				LIBS="-L${BUILD_DIR}" \
				NO_QT_VERSION_SUFFIX="yes"
		popd || die
	fi
}

src_compile() {
	cmake_src_compile

	use designer && emake -C designerPlugin

	use examples && emake -C examples
}

src_install() {
	local HTML_DOCS=( doc )

	use designer && emake -C designerPlugin INSTALL_ROOT="${D}" install

	if use examples; then
		exeinto /usr/share/${PN}/examples/bin
		doexe $(find "${S}"/examples -type f -executable ! -name '*.vcproj' ! -name 'make*')

		docinto examples
		dodoc -r "${S}"/examples-src/.
		docompress -x /usr/share/doc/${PF}/examples
	fi

	cmake_src_install
}
