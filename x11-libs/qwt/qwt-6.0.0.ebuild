# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qwt/qwt-6.0.0.ebuild,v 1.13 2014/01/07 07:04:18 jlec Exp $

EAPI=4

inherit eutils qt4-r2

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="2D plotting library for Qt4"
HOMEPAGE="http://qwt.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV/_/-}/${MY_P}.tar.bz2"

LICENSE="qwt"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 sparc x86 ~x86-macos"
SLOT="6"
IUSE="doc examples svg"

DEPEND="
	dev-qt/qtgui:4
	doc? ( !<media-libs/coin-3.1.3[doc] )
	svg? ( dev-qt/qtsvg:4 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

DOCS="CHANGES README"

src_prepare() {
	cat > qwtconfig.pri <<-EOF
		QWT_INSTALL_LIBS = "${EPREFIX}/usr/$(get_libdir)"
		QWT_INSTALL_HEADERS = "${EPREFIX}/usr/include/qwt6"
		QWT_INSTALL_DOCS = "${EPREFIX}/usr/share/doc/${PF}"
		QWT_CONFIG += QwtDll QwtPlot QwtWidgets QwtDesigner
		VERSION = ${PV/_*}
		QWT_INSTALL_PLUGINS   = "${EPREFIX}/usr/$(get_libdir)/qt4/plugins/designer6"
		QWT_INSTALL_FEATURES  = "${EPREFIX}/usr/$(get_libdir)/qt4/features6"
	EOF

	cat > qwtbuild.pri <<-EOF
		QWT_CONFIG += qt warn_on thread release no_keywords
	EOF

	# don't build examples - fix the qt files to build once installed
	cat > examples/examples.pri <<-EOF
		include( qwtconfig.pri )
		TEMPLATE     = app
		MOC_DIR      = moc
		INCLUDEPATH += "${EPREFIX}/usr/include/qwt6"
		DEPENDPATH  += "${EPREFIX}/usr/include/qwt6"
		LIBS        += -lqwt
	EOF
	sed -i -e 's:../qwtconfig:qwtconfig:' examples/examples.pro || die
	sed \
		-e 's/target doc/target/' \
		-i src/src.pro || die

	# Renaming lib to libqwt6.so to enable slotting
	sed \
		-e "/^TARGET/s:qwt:qwt6:g" \
		-i src/src.pro || die
	sed \
		-e '/qtAddLibrary/s:qwt:qwt6:g' \
		-i qwt.prf designer/designer.pro || die
	sed \
		-e 's:libqwt:libqwt6:g' \
		-i qwtbuild.pri || die

	use svg && echo "QWT_CONFIG += QwtSvg" >> qwtconfig.pri
	cp *.pri examples/ || die
}

src_compile() {
	# split compilation to allow parallel building
	emake sub-src
	emake
}

src_install () {
	rm -f doc/man/*/{_,deprecated}* || die
	qt4-r2_src_install
	if use doc; then
		dohtml -r doc/html/*
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
