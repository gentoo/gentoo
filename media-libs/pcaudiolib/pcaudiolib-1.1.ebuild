# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Portable C Audio Library"
HOMEPAGE="https://github.com/espeak-ng/pcaudiolib"
SRC_URI="https://github.com/espeak-ng/pcaudiolib/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~sparc"
IUSE="+alsa oss pulseaudio"

REQUIRED_USE="|| ( alsa oss pulseaudio )"

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.18 )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local econf_args
	econf_args=(
		$(use_with oss)
		$(use_with alsa)
		$(use_with pulseaudio)
	)
	econf "${econf_args[@]}"
}

src_install() {
	default
	rm "${ED}"/usr/lib*/libpcaudio.{a,la} || die
}
