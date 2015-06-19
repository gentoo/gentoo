# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/traverso/traverso-0.49.3.ebuild,v 1.1 2015/03/17 10:30:59 aballier Exp $

EAPI=4
inherit cmake-utils eutils flag-o-matic gnome2-utils

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="http://traverso-daw.org/"
SRC_URI="http://traverso-daw.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug jack lame lv2 mad pulseaudio"

RDEPEND=">=media-libs/flac-1.1.2
	>=media-libs/libogg-1.1.2
	media-libs/libsamplerate
	>=media-libs/libsndfile-1.0.12
	>=media-libs/libvorbis-1.1.2
	>=media-sound/wavpack-4.40.0
	>=sci-libs/fftw-3
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	jack? ( >=media-sound/jack-audio-connection-kit-0.100 )
	lame? ( media-sound/lame )
	lv2? ( media-libs/lilv )
	mad? ( >=media-libs/libmad-0.15.0 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README resources/help.text )

PATCHES=(
	"${FILESDIR}"/${PN}-0.49.2-desktop.patch
)

src_configure() {
	use lv2 && append-cppflags "$($(tc-getPKG_CONFIG) --cflags slv2)" #415165

	local mycmakeargs=(
		$(cmake-utils_use_want jack JACK)
		$(cmake-utils_use_want alsa ALSA)
		$(cmake-utils_use_want pulseaudio PULSEAUDIO)
		$(cmake-utils_use_want lv2 LV2)
		$(cmake-utils_use_want mad MP3_DECODE)
		$(cmake-utils_use_want lame MP3_ENCODE)
		$(cmake-utils_use_want debug TRAVERSO_DEBUG)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	local res
	for res in 16 24 48 64 128; do
		doicon -s ${res} resources/freedesktop/icons/${res}x${res}/apps/${PN}.png
	done
	doicon -s scalable resources/freedesktop/icons/scalable/apps/${PN}.svg

	domenu resources/traverso.desktop

	insinto /usr/share/${PN}
	doins -r resources/themes
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
