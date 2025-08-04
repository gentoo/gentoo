# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo xdg

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://hydrogen-music.org/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}-music/${PN}"
else
	MY_PV=${PV/_/-}
	SRC_URI="https://github.com/${PN}-music/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${MY_PV}
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2 ZLIB"
SLOT="0"
IUSE="alsa +archive doc jack ladspa osc oss portaudio portmidi pulseaudio test"
# Tests currently fail w/ no audio device, crashing on exit
RESTRICT="!test? ( test ) test"

DEPEND="
	dev-qt/qtbase:6[gui,network,widgets,xml]
	dev-qt/qtsvg:6
	media-libs/libsndfile
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive:= )
	!archive? ( dev-libs/libtar )
	doc? ( dev-texlive/texlive-fontutils )
	jack? ( virtual/jack )
	ladspa? ( media-libs/liblrdf )
	osc? ( media-libs/liblo )
	portaudio? ( media-libs/portaudio )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-libs/libpulse )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
	doc? ( app-text/doxygen )
	test? ( dev-util/cppunit )
"

DOCS=( AUTHORS CHANGELOG.md DEVELOPERS README.md )

PATCHES=( "${FILESDIR}/${PN}-1.2.3-cflags.patch" )

src_configure() {
	local mycmakeargs=(
		-DWANT_CPPUNIT=$(usex test)
		-DWANT_DEBUG=OFF
		-DWANT_LASH=OFF
		-DWANT_RUBBERBAND=OFF
		-DWANT_QT6=ON
		-DWANT_ALSA=$(usex alsa)
		-DWANT_LIBARCHIVE=$(usex archive)
		-DWANT_JACK=$(usex jack)
		-DWANT_LADSPA=$(usex ladspa)
		-DWANT_LRDF=$(usex ladspa)
		-DWANT_OSC=$(usex osc)
		-DWANT_OSS=$(usex oss)
		-DWANT_PORTAUDIO=$(usex portaudio)
		-DWANT_PORTMIDI=$(usex portmidi)
		-DWANT_PULSEAUDIO=$(usex pulseaudio)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_test() {
	local -x H2_HOME="${S}"
	edo "${BUILD_DIR}"/src/tests/tests -V Info
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	cmake_src_install
}
