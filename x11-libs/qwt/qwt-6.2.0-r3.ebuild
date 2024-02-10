# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
DOCS_CONFIG_NAME="Doxyfile"
DOCS_DEPEND="media-gfx/graphviz"

inherit docs multibuild qmake-utils

DESCRIPTION="2D plotting library for Qt"
HOMEPAGE="https://qwt.sourceforge.io/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="qwt"
KEYWORDS="amd64 ~arm ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
SLOT="6/2.0"
IUSE="designer doc examples opengl polar +qt5 qt6 svg"
REQUIRED_USE="|| ( qt5 qt6 )"

DEPEND="
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		designer? ( dev-qt/designer:5 )
		opengl? (
				dev-qt/qtopengl:5
				virtual/opengl
		)
		svg? ( dev-qt/qtsvg:5 )
	)
	qt6? (
		dev-qt/qtbase:6[concurrent,gui,cups,widgets]
		designer? ( dev-qt/qttools:6[designer] )
		opengl? (
			dev-qt/qtbase:6[opengl]
			virtual/opengl
		)
		svg? ( dev-qt/qtsvg:6 )
	)
"
RDEPEND="${DEPEND}"

# tests require package to be already installed
RESTRICT="test"

DOCS=( CHANGES-6.2 README )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_prepare() {
	my_src_prepare() {
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
			QWT_CONFIG += qt warn_on thread release no_keywords
			DEFINES += QWT_MOC_INCLUDE=1
		EOF

		echo "QWT_CONFIG += QwtDll" >> qwtconfig.pri

		cat >> qwtconfig.pri <<-EOF || die
			QWT_INSTALL_PLUGINS   = "${EPREFIX}/usr/$(get_libdir)/${MULTIBUILD_VARIANT}/plugins/designer"
			QWT_INSTALL_FEATURES  = "${EPREFIX}/usr/$(get_libdir)/${MULTIBUILD_VARIANT}/mkspecs/features"
		EOF
		sed \
			-e 's/target doc/target/' \
			-e "/^TARGET/s:(qwt):(qwt6-${MULTIBUILD_VARIANT}):g" \
			-e "/^TARGET/s:qwt):qwt6-${MULTIBUILD_VARIANT}):g" \
			-e "s:QWT_SONAME=libqwt.so:QWT_SONAME=libqwt6-${MULTIBUILD_VARIANT}.so:g" \
			-i src/src.pro || die

		sed \
			-e "/qwtAddLibrary/s:(qwt):(qwt6-${MULTIBUILD_VARIANT}):g" \
			-e "/qwtAddLibrary/s:qwt):qwt6-${MULTIBUILD_VARIANT}):g" \
			-i qwt.prf designer/designer.pro examples/examples.pri || die
	}
	default
	multibuild_copy_sources
	multibuild_foreach_variant run_in_build_dir my_src_prepare
}

src_configure() {
	my_src_configure() {
		case ${MULTIBUILD_VARIANT} in
			qt5) eqmake5 ;;
			qt6) eqmake6 ;;
		esac
	}
	multibuild_foreach_variant run_in_build_dir my_src_configure
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir emake

	# need doxyfilter.sh in PATH
	PATH="${PATH}:${S}/doc/" docs_compile
}

src_test() {
	my_src_test() {
		cd "${BUILD_DIR}"/tests || die
		case ${MULTIBUILD_VARIANT} in
			qt5) eqmake5 tests.pro ;;
			qt6) eqmake6 tests.pro ;;
		esac
		emake
	}
	multibuild_foreach_variant my_src_test
}

src_install() {
	multibuild_foreach_variant run_in_build_dir emake INSTALL_ROOT="${D}" install
	einstalldocs

	mkdir -p "${ED}"/usr/share/man/ || die
	mv "${ED}"/usr/share/doc/${PF}/man/man3 "${ED}"/usr/share/man/ && \
		rmdir "${ED}"/usr/share/doc/${PF}/man || die

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
