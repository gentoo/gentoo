# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multibuild qmake-utils

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="2D plotting library for Qt4 and Qt5"
HOMEPAGE="http://qwt.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV/_/-}/${MY_P}.tar.bz2"

LICENSE="qwt mathml? ( LGPL-2.1 Nokia-Qt-LGPL-Exception-1.1 )"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
SLOT="6/1.3"
IUSE="designer doc examples mathml opengl qt4 qt5 static-libs svg"

REQUIRED_USE="|| ( qt4 qt5 )"

DEPEND="
	opengl? ( virtual/opengl )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		designer? ( dev-qt/designer:4 )
		opengl? ( dev-qt/qtopengl:4 )
		svg? ( dev-qt/qtsvg:4 )
	)
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		designer? ( dev-qt/designer:5 )
		opengl? ( dev-qt/qtopengl:5 )
		svg? ( dev-qt/qtsvg:5 )
	)
"
RDEPEND="${DEPEND}
	!<x11-libs/qwt-5.2.3
	!x11-libs/qwt:5[doc]
	doc? ( !<media-libs/coin-3.1.3[doc] )
"

S="${WORKDIR}"/${MY_P}

DOCS=( CHANGES-6.1 README )

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.2-invalid-read.patch
	"${FILESDIR}"/${PN}-6.1.1-pc-destdir.patch
)

src_prepare() {
	cat > qwtconfig.pri <<-EOF
		QWT_INSTALL_LIBS = "${EPREFIX}/usr/$(get_libdir)"
		QWT_INSTALL_HEADERS = "${EPREFIX}/usr/include/qwt6"
		QWT_INSTALL_DOCS = "${EPREFIX}/usr/share/doc/${PF}"
		QWT_CONFIG += QwtPlot QwtWidgets QwtPkgConfig
		VERSION = ${PV/_*}
		QWT_VERSION = ${PV/_*}
	EOF

	use designer && echo "QWT_CONFIG += QwtDesigner" >> qwtconfig.pri
	use mathml && echo "QWT_CONFIG += QwtMathML" >> qwtconfig.pri
	use opengl && echo "QWT_CONFIG += QwtOpenGL" >> qwtconfig.pri
	use svg && echo "QWT_CONFIG += QwtSvg" >> qwtconfig.pri

	cat > qwtbuild.pri <<-EOF
		QWT_CONFIG += qt warn_on thread release no_keywords
	EOF

	MULTIBUILD_VARIANTS=( )

	if use qt4; then
		use static-libs && MULTIBUILD_VARIANTS+=( qt4-static )
		MULTIBUILD_VARIANTS+=( qt4-shared )
	fi

	if use qt5; then
		use static-libs && MULTIBUILD_VARIANTS+=( qt5-static )
		MULTIBUILD_VARIANTS+=( qt5-shared )
	fi

	multibuild_copy_sources

	preparation() {
		if [[ ${MULTIBUILD_VARIANT} == *-shared ]]; then
			echo "QWT_CONFIG += QwtDll" >> qwtconfig.pri
		fi

		case "${MULTIBUILD_VARIANT}" in
			qt4-*)
				cat >> qwtconfig.pri <<-EOF
					QWT_INSTALL_PLUGINS   = "${EPREFIX}$(qt4_get_plugindir)/designer"
					QWT_INSTALL_FEATURES  = "${EPREFIX}$(qt4_get_mkspecsdir)/features"
				EOF
				sed \
					-e 's/target doc/target/' \
					-e "/^TARGET/s:(qwt):(qwt6-qt4):g" \
					-e "/^TARGET/s:qwt):qwt6-qt4):g" \
					-i src/src.pro || die

				sed \
					-e '/qwtAddLibrary/s:(qwt):(qwt6-qt4):g' \
					-e '/qwtAddLibrary/s:qwt):qwt6-qt4):g' \
					-i qwt.prf designer/designer.pro examples/examples.pri \
					textengines/mathml/qwtmathml.prf textengines/textengines.pri || die

			;;
			qt5-*)
				cat >> qwtconfig.pri <<-EOF
					QWT_INSTALL_PLUGINS   = "${EPREFIX}$(qt5_get_plugindir)/designer"
					QWT_INSTALL_FEATURES  = "${EPREFIX}$(qt5_get_mkspecsdir)/features"
				EOF
				sed \
					-e 's/target doc/target/' \
					-e "/^TARGET/s:(qwt):(qwt6-qt5):g" \
					-e "/^TARGET/s:qwt):qwt6-qt5):g" \
					-i src/src.pro || die

				sed \
					-e '/qwtAddLibrary/s:(qwt):(qwt6-qt5):g' \
					-e '/qwtAddLibrary/s:qwt):qwt6-qt5):g' \
					-i qwt.prf designer/designer.pro examples/examples.pri \
					textengines/mathml/qwtmathml.prf textengines/textengines.pri || die
			;;
		esac
		default
	}

	multibuild_foreach_variant run_in_build_dir preparation
}

src_configure() {
	configuration() {
		case "${MULTIBUILD_VARIANT}" in
			qt4-*)
				eqmake4
				;;
			qt5-*)
				eqmake5
				;;
		esac
	}
	multibuild_foreach_variant run_in_build_dir configuration
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir default
}

src_test() {
	testing() {
		cd examples || die
		case "${MULTIBUILD_VARIANT}" in
			qt4-*)
				eqmake4 examples.pro
				;;
			qt5-*)
				eqmake5 examples.pro
				;;
		esac
		emake
	}
	multibuild_foreach_variant run_in_build_dir testing
}

src_install () {
	rm -f doc/man/*/{_,deprecated}* || die

	multibuild_foreach_variant run_in_build_dir emake INSTALL_ROOT="${D}" install

	if use qt4; then
		mv "${ED}"/usr/$(get_libdir)/pkgconfig/qwt6{-qt4,}.pc || die
	fi

	if use mathml; then
		sed \
			-e "s: -L\"${WORKDIR}\".* -lqwt6: -lqwt6:g" \
			-i "${ED}"/usr/$(get_libdir)/pkgconfig/qwtmathml.pc || die
	fi

	if use doc; then
		HTML_DOCS=( doc/html/. )
	else
		rm -rf "${ED}"/usr/share/doc/${PF}/html || die
	fi

	einstalldocs

	mkdir -p "${ED}"/usr/share/man/ || die
	mv "${ED}"/usr/share/doc/${PF}/man/man3 "${ED}"/usr/share/man/ && \
		rmdir "${ED}"/usr/share/doc/${PF}/man || die

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
