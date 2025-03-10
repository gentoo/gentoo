# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Desktop session recorder producing Ogg video/audio files"
HOMEPAGE="https://enselic.github.io/recordmydesktop/"
SRC_URI="https://github.com/Enselic/recordmydesktop/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="alsa jack"

RDEPEND="x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXdamage
	media-libs/libvorbis
	media-libs/libogg
	media-libs/libtheora[encode]
	x11-libs/libICE
	x11-libs/libSM
	alsa? ( media-libs/alsa-lib )
	jack? ( virtual/jack )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable !alsa oss) \
		$(use_enable jack)
}
