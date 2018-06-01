# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=1a477ffe380f153c5d9fb3495d9874df7f75334f
inherit cmake-utils vcs-snapshot xdg-utils

DESCRIPTION="Advanced drum machine"
HOMEPAGE="http://www.hydrogen-music.org/"
SRC_URI="https://github.com/${PN}-music/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 ZLIB"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="alsa +archive jack ladspa lash osc oss portaudio portmidi pulseaudio"

REQUIRED_USE="lash? ( alsa )"

RDEPEND="
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
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog DEVELOPERS README.txt )

PATCHES=( "${FILESDIR}/${P}-gnuinstalldirs.patch" )

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

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dosym ../../${PN}/data/doc /usr/share/doc/${PF}/html
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
