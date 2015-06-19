# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qwt/qwt-5.2.3-r2.ebuild,v 1.14 2015/06/07 09:46:45 maekke Exp $

EAPI=5

inherit eutils multibuild qt4-r2

DESCRIPTION="2D plotting library for Qt4"
HOMEPAGE="http://qwt.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="qwt"
KEYWORDS="~alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-macos"
SLOT="5"
IUSE="doc examples static-libs svg"

DEPEND="
	dev-qt/designer:4
	dev-qt/qtgui:4
	doc? ( !<media-libs/coin-3.1.3[doc] )
	svg? ( dev-qt/qtsvg:4 )"
RDEPEND="${DEPEND}"

DOCS="CHANGES README"

src_prepare() {
	epatch "${FILESDIR}"/${P}-install_qt.patch
	sed -e "/QwtVersion/s:5.2.2.:${PV}:g" -i ${PN}.prf || die

	cat > qwtconfig.pri <<-EOF
		target.path = "${EPREFIX}/usr/$(get_libdir)"
		headers.path = "${EPREFIX}/usr/include/qwt5"
		doc.path = "${EPREFIX}/usr/share/doc/${PF}"
		CONFIG += qt warn_on thread release
		CONFIG += QwtPlot QwtWidgets QwtDesigner
		VERSION = ${PV}
		QWT_VERSION = ${PV/_*}
		QWT_INSTALL_PLUGINS   = "${EPREFIX}/usr/$(get_libdir)/qt4/plugins/designer"
		QWT_INSTALL_FEATURES  = "${EPREFIX}/usr/share/qt4/mkspecs/features"
	EOF
	sed -i -e 's/headers doc/headers/' src/src.pro || die
	use svg && echo >> qwtconfig.pri "CONFIG += QwtSVGItem"

	MULTIBUILD_VARIANTS=( )
	use static-libs && MULTIBUILD_VARIANTS+=( static )
	MULTIBUILD_VARIANTS+=( shared )

	qt4-r2_src_prepare

	preparation() {
		cp -rf "${S}" "${BUILD_DIR}" || die
		[[ ${MULTIBUILD_VARIANT} == shared ]] && \
			echo "CONFIG += QwtDll" >> "${BUILD_DIR}"/qwtconfig.pri
	}

	multibuild_foreach_variant preparation
}

src_configure() {
	multibuild_parallel_foreach_variant run_in_build_dir eqmake4 ${PN}.pro
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
	multibuild_foreach_variant run_in_build_dir qt4-r2_src_install

	if use doc; then
		insinto /usr/share/doc/${PF}
		rm doc/man/*/*license* || die
		rm -f doc/man/*/{_,deprecated}* || die
		doman doc/man/*/*
		doins -r doc/html
	fi
	if use examples; then
		# don't build examples - fix the qt files to build once installed
		cat > examples/examples.pri <<-EOF
			include( qwtconfig.pri )
			TEMPLATE     = app
			MOC_DIR      = moc
			INCLUDEPATH += "${EPREFIX}/usr/include/qwt5"
			DEPENDPATH  += "${EPREFIX}/usr/include/qwt5"
			LIBS        += -lqwt
		EOF
		sed -i -e 's:../qwtconfig:qwtconfig:' examples/examples.pro || die
		cp *.pri examples/ || die
		insinto /usr/share/${PN}5
		doins -r examples
	fi
}
