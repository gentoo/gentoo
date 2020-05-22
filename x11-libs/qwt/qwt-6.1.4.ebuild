# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="2D plotting library for Qt5"
HOMEPAGE="https://qwt.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="qwt mathml? ( LGPL-2.1 Nokia-Qt-LGPL-Exception-1.1 )"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
SLOT="6/1.4"
IUSE="designer doc examples mathml opengl svg"

DEPEND="
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
"
RDEPEND="${DEPEND}"

DOCS=( CHANGES-6.1 README )

PATCHES=(
	"${FILESDIR}"/${PN}-6.0.2-invalid-read.patch
	"${FILESDIR}"/${PN}-6.1.1-pc-destdir.patch
	"${FILESDIR}"/${P}-qt-5.15.patch # trunk
)

src_prepare() {
	default

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

	echo "QWT_CONFIG += QwtDll" >> qwtconfig.pri

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
}

src_configure() {
	eqmake5
}

src_compile() {
	default
}

src_test() {
	cd examples || die
	eqmake5 examples.pro
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	if use mathml; then
		sed \
			-e "s: -L\"${WORKDIR}\".* -lqwt6: -lqwt6:g" \
			-i "${ED}"/usr/$(get_libdir)/pkgconfig/qwtmathml.pc || die
	fi

	if use doc; then
		local HTML_DOCS=( doc/html/. )
	else
		rm -r "${ED}"/usr/share/doc/${PF}/html || die
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
