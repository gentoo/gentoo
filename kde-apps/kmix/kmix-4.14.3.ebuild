# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/kmix/kmix-4.14.3.ebuild,v 1.1 2015/06/04 18:44:40 kensington Exp $

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE mixer gui"
HOMEPAGE="http://www.kde.org/applications/multimedia/kmix/"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="alsa debug canberra pulseaudio"

DEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.14a )
	canberra? ( media-libs/libcanberra )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.12 )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with canberra)
		$(cmake-utils_use_with pulseaudio PulseAudio)
	)

	kde4-base_src_configure
}
