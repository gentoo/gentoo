# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="2D plotting library for Qt"
HOMEPAGE="https://qwt.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="qwt"
SLOT="6/3.0"
KEYWORDS="~amd64 ~arm ~ppc64 ~riscv ~x86"
IUSE="designer doc examples opengl polar svg"

# tests require package to be already installed
RESTRICT="test"

DEPEND="
	dev-qt/qtbase:6[concurrent,gui,widgets]
	designer? ( dev-qt/qttools:6[designer] )
	opengl? (
		dev-qt/qtbase:6[opengl]
		virtual/opengl
	)
	svg? ( dev-qt/qtsvg:6 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	cat > qwtconfig.pri <<-EOF || die
		QWT_INSTALL_LIBS = "${EPREFIX}/usr/$(get_libdir)"
		QWT_INSTALL_HEADERS = "${EPREFIX}/usr/include/qwt6"
		QWT_INSTALL_DOCS = "${EPREFIX}/usr/share/doc/${PF}"
		QWT_CONFIG += QwtPlot QwtWidgets QwtPkgConfig
		VER_MAJ = $(ver_cut 1)
		VER_MIN = $(ver_cut 2)
		VER_PAT = $(ver_cut 3)
		VERSION = ${PV/_*}
		QWT_VER_MAJ = $(ver_cut 1)
		QWT_VER_MIN = $(ver_cut 2)
		QWT_VER_PAT = $(ver_cut 3)
		QWT_VERSION = ${PV/_*}
	EOF

	use designer && echo "QWT_CONFIG += QwtDesigner" >> qwtconfig.pri
	use opengl && echo "QWT_CONFIG += QwtOpenGL" >> qwtconfig.pri
	use polar && echo "QWT_CONFIG += QwtPolar" >> qwtconfig.pri
	use svg && echo "QWT_CONFIG += QwtSvg" >> qwtconfig.pri

	cat > qwtbuild.pri <<-EOF || die
		QWT_CONFIG += qt warn_on thread release no_keywords QwtDll
		DEFINES += QWT_MOC_INCLUDE=1
	EOF

	cat >> qwtconfig.pri <<-EOF || die
		QWT_INSTALL_PLUGINS   = "${EPREFIX}/usr/$(get_libdir)/qt6/plugins/designer"
		QWT_INSTALL_FEATURES  = "${EPREFIX}/usr/$(get_libdir)/qt6/mkspecs/features"
	EOF
	sed \
		-e 's/target doc/target/' \
		-e "/^TARGET/s:(qwt):(qwt6-qt6):g" \
		-e "/^TARGET/s:qwt):qwt6-qt6):g" \
		-e "s:QWT_SONAME=libqwt.so:QWT_SONAME=libqwt6-qt6.so:g" \
		-i src/src.pro || die

	sed \
		-e "/qwtAddLibrary/s:(qwt):(qwt6-qt6):g" \
		-e "/qwtAddLibrary/s:qwt):qwt6-qt6):g" \
		-i qwt.prf designer/designer.pro examples/examples.pri || die

	if ! use doc; then
		sed -e 's/doc//' -i qwt.pro || die
	fi
	default
}

src_configure() {
	eqmake6
}

src_test() {
	pushd "${BUILD_DIR}"/tests > /dev/null || die
		eqmake6 tests.pro
	popd > /dev/null || die
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs

	if use doc; then
		mkdir -p "${ED}"/usr/share/man/ || die
		mv "${ED}"/usr/share/doc/${PF}/man/man3 "${ED}"/usr/share/man/ && \
			rmdir "${ED}"/usr/share/doc/${PF}/man || die
	fi

	if use examples; then
		# don't build examples - fix the qt files to build once installed
		cat > examples/examples.pri <<-EOF || die
			include( qwtconfig.pri )
			TEMPLATE     = app
			MOC_DIR      = moc
			INCLUDEPATH += "${EPREFIX}/usr/include/qwt6"
			DEPENDPATH  += "${EPREFIX}/usr/include/qwt6"
			LIBS        += -lqwt6
		EOF
		sed -i -e 's:../qwtconfig:qwtconfig:' examples/examples.pro || die
		cp *.pri examples/ || die
		insinto /usr/share/${PN}6
		doins -r examples
	fi
}
