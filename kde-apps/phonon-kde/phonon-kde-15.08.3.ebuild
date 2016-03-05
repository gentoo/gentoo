# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="https://phonon.kde.org"
KEYWORDS=" amd64 ~x86"
IUSE="alsa debug pulseaudio"

DEPEND="
	media-libs/phonon[qt4]
	alsa? ( media-libs/alsa-lib )
	pulseaudio? (
		dev-libs/glib:2
		media-libs/libcanberra
		>=media-sound/pulseaudio-0.9.21[glib]
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_tests=OFF
		-DWITH_Xine=OFF
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with pulseaudio PulseAudio)
	)

	kde4-meta_src_configure
}
