# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == 9999 ]] && inherit git-r3
inherit desktop qmake-utils xdg

DESCRIPTION="Convert an image file showing a graph or map into numbers"
HOMEPAGE="https://akhuettel.github.io/engauge-digitizer/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/akhuettel/engauge-digitizer"
	S=${WORKDIR}/engauge-${PV}
else
	SRC_URI="https://github.com/akhuettel/engauge-digitizer/archive/v${PV}.tar.gz -> engauge-digitizer-${PV}.tar.gz"
	KEYWORDS="amd64 ~x86"
	S=${WORKDIR}/engauge-digitizer-${PV}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="doc examples jpeg2k pdf"

RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets,xml]
	dev-qt/qttools:6[assistant]
	dev-libs/log4cpp
	media-libs/libjpeg-turbo:0=
	media-libs/libpng:0=
	sci-libs/fftw:3.0
	jpeg2k? ( media-libs/openjpeg:2 )
	pdf? ( app-text/poppler[qt6] )"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[assistant]"

src_prepare() {
	xdg_environment_reset
	default

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
	eqmake6 \
		CONFIG+=link_pkgconfig \
		$(usex jpeg2k "CONFIG+=jpeg2000 PKGCONFIG+=libopenjp2" "") \
		$(usex pdf "CONFIG+=pdf PKGCONFIG+=poppler-qt6" "") \
		engauge.pro
	pushd help >/dev/null || die
	$(qt6_get_libexecdir)/qhelpgenerator engauge.qhp || die
	popd >/dev/null || die
}

src_install() {
	dobin bin/Engauge
	doicon src/img/engauge-digitizer.svg
	make_desktop_entry Engauge "Engauge Digitizer" engauge-digitizer Graphics

	# Install qt help files
	dodoc help/engauge.qch
	docompress -x "${EPREFIX}"/usr/share/doc/${PF}/engauge.qch

	use doc && dodoc -r doc/.
	if use examples; then
		dodoc -r samples
		docompress -x "${EPREFIX}"/usr/share/doc/${PF}/samples
	fi

	dosym Engauge /usr/bin/engauge
}
