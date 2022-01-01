# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://www.hydrogen-music.org/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}-music/${PN}"
	KEYWORDS=""
else
	MY_PV=${PV/_/-}
	SRC_URI="https://github.com/${PN}-music/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
	S="${WORKDIR}"/${PN}-${MY_PV}
fi

LICENSE="GPL-2 ZLIB"
SLOT="0"
IUSE="alsa +archive doc jack ladspa lash osc oss portaudio portmidi pulseaudio"

REQUIRED_USE="lash? ( alsa )"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
CDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
	>=media-libs/libsndfile-1.0.18
	alsa? ( media-libs/alsa-lib )
	archive? ( app-arch/libarchive )
	!archive? ( >=dev-libs/libtar-1.2.11-r3 )
	jack? ( virtual/jack )
	ladspa? ( media-libs/liblrdf )
	lash? ( media-sound/lash )
	osc? ( media-libs/liblo )
	portaudio? ( media-libs/portaudio )
	portmidi? ( media-libs/portmidi )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="
	${CDEPEND}
	dev-qt/qttest:5
"
RDEPEND="${CDEPEND}"

DOCS=( AUTHORS ChangeLog DEVELOPERS README.txt )

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-gnuinstalldirs.patch"
	"${FILESDIR}/${P}-i18n-path.patch"
)

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWANT_ALSA=$(usex alsa)
		-DWANT_CPPUNIT=OFF
		-DWANT_DEBUG=OFF
		-DWANT_JACK=$(usex jack)
		-DWANT_JACKSESSION=$(usex jack)
		-DWANT_LADSPA=$(usex ladspa)
		-DWANT_LASH=$(usex lash)
		-DWANT_LIBARCHIVE=$(usex archive)
		-DWANT_LRDF=$(usex ladspa)
		-DWANT_OSC=$(usex osc)
		-DWANT_OSS=$(usex oss)
		-DWANT_PORTAUDIO=$(usex portaudio)
		-DWANT_PORTMIDI=$(usex portmidi)
		-DWANT_PULSEAUDIO=$(usex pulseaudio)
		-DWANT_RUBBERBAND=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	cmake_src_install
}
