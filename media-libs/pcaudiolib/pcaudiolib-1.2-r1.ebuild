# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Portable C Audio Library"
HOMEPAGE="https://github.com/espeak-ng/pcaudiolib"
SRC_URI="https://github.com/espeak-ng/pcaudiolib/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ ZLIB"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="+alsa oss pulseaudio"

REQUIRED_USE="|| ( alsa oss pulseaudio )"

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.18 )
	pulseaudio? ( media-sound/pulseaudio )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/0001-Fix-audio-choppiness-on-some-systems.patch"
	"${FILESDIR}/0002-Fix-latency-related-buffer-sizing.patch"
	"${FILESDIR}/0003-Copy-audio-buffer-and-send-for-playback-without-bloc.patch"
	)

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
		--disable-static
	)
	econf "${econf_args[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
