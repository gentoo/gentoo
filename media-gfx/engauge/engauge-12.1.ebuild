# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg

DESCRIPTION="Convert an image file showing a graph or map into numbers"
HOMEPAGE="https://markummitchell.github.io/engauge-digitizer/"
SRC_URI="https://github.com/markummitchell/engauge-digitizer/archive/v${PV}.tar.gz -> engauge-digitizer-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="doc examples jpeg2k pdf"

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qthelp:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-libs/log4cpp
	media-libs/libpng:0=
	sci-libs/fftw:3.0
	virtual/jpeg
	jpeg2k? ( media-libs/openjpeg:2 )
	pdf? ( app-text/poppler[qt5] )"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qthelp:5"

S=${WORKDIR}/engauge-digitizer-${PV}

src_prepare() {
	xdg_src_prepare

	# Make sure the documentation is looked for in the proper directory
	sed -e "s:engauge-digitizer/engauge.qhc:${PF}/engauge.qhc:" \
		-i src/Help/HelpWindow.cpp || die

	# This otherwise overrides user CFLAGS
	sed -e '/QMAKE_CXXFLAGS_WARN_ON/s/-O1//' \
		-i engauge.pro || die

	# Neuter the non-pkg-config hackery
	sed -e '/error.*OPENJPEG_/d' \
		-e '/LIBS.*OPENJPEG_LIB/d' \
		-e '/QMAKE_POST_LINK.*OPENJPEG_LIB/d' \
		-e '/error.*POPPLER_/d' \
		-e '/LIBS.*POPPLER_LIB/d' \
		-i engauge.pro || die
}

src_configure() {
	eqmake5 \
		CONFIG+=link_pkgconfig \
		$(usex jpeg2k "CONFIG+=jpeg2000 PKGCONFIG+=libopenjp2" "") \
		$(usex pdf "CONFIG+=pdf PKGCONFIG+=poppler-qt5" "") \
		engauge.pro
	pushd help >/dev/null || die
	$(qt5_get_bindir)/qhelpgenerator engauge.qhp || die
	popd >/dev/null || die
}

src_install() {
	dobin bin/engauge
	doicon src/img/engauge-digitizer.svg
	make_desktop_entry engauge "Engauge Digitizer" engauge-digitizer Graphics

	# Install qt help files
	dodoc help/engauge.qch
	docompress -x "${EPREFIX}"/usr/share/doc/${PF}/engauge.qch

	use doc && dodoc -r doc/.
	if use examples; then
		dodoc -r samples
		docompress -x "${EPREFIX}"/usr/share/doc/${PF}/samples
	fi
}
