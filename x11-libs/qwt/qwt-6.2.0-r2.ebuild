# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="doxygen"
DOCS_DIR="doc"
DOCS_CONFIG_NAME="Doxyfile"
DOCS_DEPEND="media-gfx/graphviz"

inherit qmake-utils docs

DESCRIPTION="2D plotting library for Qt5"
HOMEPAGE="https://qwt.sourceforge.io/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"

LICENSE="qwt"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
SLOT="6/2.0"
IUSE="designer doc examples opengl polar svg"

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

# tests require package to be already installed
RESTRICT="test"

DOCS=( CHANGES-6.2 README )

src_prepare() {
	default

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
		QWT_INSTALL_PLUGINS   = "${EPREFIX}$(qt5_get_plugindir)/designer"
		QWT_INSTALL_FEATURES  = "${EPREFIX}$(qt5_get_mkspecsdir)/features"
	EOF
	sed \
		-e 's/target doc/target/' \
		-e "/^TARGET/s:(qwt):(qwt6-qt5):g" \
		-e "/^TARGET/s:qwt):qwt6-qt5):g" \
		-e "s:QWT_SONAME=libqwt.so:QWT_SONAME=libqwt6-qt5.so:g" \
		-i src/src.pro || die

	sed \
		-e '/qwtAddLibrary/s:(qwt):(qwt6-qt5):g' \
		-e '/qwtAddLibrary/s:qwt):qwt6-qt5):g' \
		-i qwt.prf designer/designer.pro examples/examples.pri || die
}

src_configure() {
	eqmake5
}

src_compile() {
	default
	# need doxyfilter.sh in PATH
	PATH="${PATH}:${S}/doc/" docs_compile
}

src_test() {
	cd tests || die
	eqmake5 tests.pro
	emake
}

src_install() {
	emake INSTALL_ROOT="${D}" install
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
