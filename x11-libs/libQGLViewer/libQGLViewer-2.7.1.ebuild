# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit qmake-utils multilib flag-o-matic

DESCRIPTION="C++ library based on Qt that eases the creation of OpenGL 3D viewers"
HOMEPAGE="http://www.libqglviewer.com"
SRC_URI="http://www.libqglviewer.com/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/qt5"
KEYWORDS="~amd64 ~arm"
IUSE="designer examples"

DEPEND="virtual/opengl
	virtual/glu
	dev-qt/qtopengl:5
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtgui:5"
RDEPEND="${DEPEND}
	designer? ( dev-qt/designer:5 )"

src_configure() {
	append-ldflags "-L${S}/QGLViewer"
	sed -e 's#designerPlugin##' -i ${P}.pro || die
	use examples || sed -e 's#examples examples/contribs##' -i ${P}.pro || die
	eqmake5 ${P}.pro \
		PREFIX="${EPREFIX}/usr" \
		LIB_DIR="${EPREFIX}/usr/$(get_libdir)" \
		DOC_DIR="${EPREFIX}/usr/share/doc/${PF}/html"
	if use designer ; then
		cd "${S}/designerPlugin"
		eqmake5 designerPlugin.pro
	fi
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README

	if use designer ; then
		cd "${S}/designerPlugin"
		emake INSTALL_ROOT="${D}" install
	fi

	if use examples ; then
		exeinto /usr/bin/${PN}-examples
		doexe $(find "${S}/examples" -type f -executable ! -name '*.vcproj')
	fi
}
