# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/phonon-kde/phonon-kde-4.14.3.ebuild,v 1.1 2015/06/04 18:44:43 kensington Exp $

EAPI=5

KMNAME="kde-runtime"
KMMODULE="phonon"
inherit kde4-meta

DESCRIPTION="Phonon KDE Integration"
HOMEPAGE="http://phonon.kde.org"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
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
