# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop flag-o-matic gnome2-utils toolchain-funcs xdg-utils

DESCRIPTION="Professional Audio Tools for GNU/Linux"
HOMEPAGE="https://traverso-daw.org/"
SRC_URI="https://traverso-daw.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug jack lame lv2 mad pulseaudio"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	>=media-libs/flac-1.1.2
	>=media-libs/libogg-1.1.2
	media-libs/libsamplerate
	>=media-libs/libsndfile-1.0.12
	>=media-libs/libvorbis-1.1.2
	>=media-sound/wavpack-4.40.0
	>=sci-libs/fftw-3
	alsa? ( >=media-libs/alsa-lib-1.0.0 )
	jack? ( virtual/jack )
	lame? ( media-sound/lame )
	lv2? ( media-libs/lilv )
	mad? ( >=media-libs/libmad-0.15.0 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README resources/help.text )

PATCHES=( "${FILESDIR}"/${PN}-0.49.2-desktop.patch )

src_configure() {
	use lv2 && append-cppflags "$($(tc-getPKG_CONFIG) --cflags slv2)" #415165

	local mycmakeargs=(
		-DWANT_ALSA=$(usex alsa)
		-DWANT_TRAVERSO_DEBUG=$(usex debug)
		-DWANT_JACK=$(usex jack)
		-DWANT_MP3_ENCODE=$(usex lame)
		-DWANT_LV2=$(usex lv2)
		-DWANT_MP3_DECODE=$(usex mad)
		-DWANT_PULSEAUDIO=$(usex pulseaudio)
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

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
