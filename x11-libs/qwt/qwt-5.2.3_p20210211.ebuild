# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

COMMIT="2a9f1ae2f394abf3a000906b507a0d925b1e4b25"

DESCRIPTION="2D plotting library for Qt5"
HOMEPAGE="https://qwt.sourceforge.io/ https://github.com/SciDAVis/qwt5-qt5"
SRC_URI="https://github.com/SciDAVis/qwt5-qt5/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="qwt"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
SLOT="5"
IUSE="designer examples"

DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtsvg:5
	designer? ( dev-qt/designer:5 )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}5-qt5-${COMMIT}"

src_prepare() {
	default
	sed -e "/QwtVersion/s:5.2.2.:${PV/_*}:g" -i ${PN}.prf || die

	cat > qwtconfig.pri <<-EOF
		target.path = "${EPREFIX}/usr/$(get_libdir)"
		headers.path = "${EPREFIX}/usr/include/qwt5"
		doc.path = "${EPREFIX}/usr/share/doc/${PF}"
		CONFIG += qt warn_on thread release
		CONFIG += QwtDll QwtPlot QwtWidgets QwtSVGItem
		VERSION = ${PV/_*}
		QWT_VERSION = ${PV/_*}
	EOF
	use designer && echo "CONFIG += QwtDesigner" >> qwtconfig.pri
	# Fails to compile with MathML enabled
	#use mathml && echo "CONFIG += QwtMathML" >> qwtconfig.pri

	cat >> qwtconfig.pri <<-EOF
		QWT_INSTALL_PLUGINS   = "${EPREFIX}$(qt5_get_plugindir)/designer"
		QWT_INSTALL_FEATURES  = "${EPREFIX}$(qt5_get_mkspecsdir)/features"
	EOF
	sed -i -e 's/headers doc/headers/' src/src.pro || die
}

src_configure() {
	eqmake5
}

src_compile() {
	default
}

src_install () {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	doman doc/man/*/*

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

	# avoid file conflict with qwt:6
	# https://github.com/gbm19/qwt5-qt5/issues/2
	pushd "${ED}/usr/share/man/man3/" || die
		for f in *; do
			mv ${f} ${f//.3/.5qt5.3} || die
		done
	popd || die
}
