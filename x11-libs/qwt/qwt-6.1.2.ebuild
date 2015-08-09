# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multibuild qt4-r2

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="2D plotting library for Qt4"
HOMEPAGE="http://qwt.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV/_/-}/${MY_P}.tar.bz2"

LICENSE="qwt mathml? ( LGPL-2.1 Nokia-Qt-LGPL-Exception-1.1 )"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
SLOT="6"
IUSE="doc examples mathml opengl static-libs svg"

DEPEND="
	!<x11-libs/qwt-5.2.3
	dev-qt/designer:4
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	doc? ( !<media-libs/coin-3.1.3[doc] )
	opengl? (
		dev-qt/qtopengl:4
		virtual/opengl
		)
	svg? ( dev-qt/qtsvg:4 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

DOCS="README"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.2-invalid-read.patch
	"${FILESDIR}"/${PN}-6.1.1-pc-destdir.patch
	)

src_prepare() {
	cat > qwtconfig.pri <<-EOF
		QWT_INSTALL_LIBS = "${EPREFIX}/usr/$(get_libdir)"
		QWT_INSTALL_HEADERS = "${EPREFIX}/usr/include/qwt6"
		QWT_INSTALL_DOCS = "${EPREFIX}/usr/share/doc/${PF}"
		QWT_CONFIG += QwtPlot QwtWidgets QwtDesigner QwtPkgConfig
		VERSION = ${PV/_*}
		QWT_VERSION = ${PV/_*}
		QWT_INSTALL_PLUGINS   = "${EPREFIX}/usr/$(get_libdir)/qt4/plugins/designer"
		QWT_INSTALL_FEATURES  = "${EPREFIX}/usr/share/qt4/mkspecs/features"
	EOF

	use mathml && echo "QWT_CONFIG += QwtMathML" >> qwtconfig.pri
	use opengl && echo "QWT_CONFIG += QwtOpenGL" >> qwtconfig.pri
	use svg && echo "QWT_CONFIG += QwtSvg" >> qwtconfig.pri

	cat > qwtbuild.pri <<-EOF
		QWT_CONFIG += qt warn_on thread release no_keywords
	EOF

	sed \
		-e 's/target doc/target/' \
		-e "/^TARGET/s:(qwt):(qwt6):g" \
		-i src/src.pro || die

	sed \
		-e '/qwtAddLibrary/s:qwt):qwt6):g' \
		-i qwt.prf designer/designer.pro examples/examples.pri \
		textengines/mathml/qwtmathml.prf textengines/textengines.pri \
		designer/designer.pro || die

	MULTIBUILD_VARIANTS=( )
	use static-libs && MULTIBUILD_VARIANTS+=( static )
	MULTIBUILD_VARIANTS+=( shared )

	qt4-r2_src_prepare

	multibuild_copy_sources
	preparation() {
		[[ ${MULTIBUILD_VARIANT} == shared ]] && \
			echo "QWT_CONFIG += QwtDll" >> "${BUILD_DIR}"/qwtconfig.pri
	}

	multibuild_foreach_variant preparation
}

src_configure() {
	multibuild_parallel_foreach_variant run_in_build_dir qt4-r2_src_configure
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir qt4-r2_src_compile
}

src_test() {
	testing() {
		cd examples || die
		eqmake4 examples.pro
		emake
	}
	multibuild_foreach_variant run_in_build_dir testing
}

src_install () {
	rm -f doc/man/*/{_,deprecated}* || die
	multibuild_foreach_variant run_in_build_dir qt4-r2_src_install

	if use mathml; then
		sed \
			-e "s: -L${WORKDIR}.* -lqwt6: -lqwt6:g" \
			-i "${ED}"/usr/$(get_libdir)/pkgconfig/qwtmathml.pc || die
	fi

	use doc && dohtml -r doc/html/*

	if use examples; then
		# don't build examples - fix the qt files to build once installed
		cat > examples/examples.pri <<-EOF
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
