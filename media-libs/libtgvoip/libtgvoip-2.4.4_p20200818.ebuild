# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

EGIT_COMMIT="7563a96b8f8e86b7a5fd1ce783388adf29bf4cf9"

DESCRIPTION="VoIP library for Telegram clients"
HOMEPAGE="https://github.com/telegramdesktop/libtgvoip"
SRC_URI="https://github.com/telegramdesktop/libtgvoip/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="+alsa +dsp libressl pulseaudio"

DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	media-libs/opus:=
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="|| ( alsa pulseaudio )"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	sed -i 's/-std=gnu++0x/-std=gnu++17/' Makefile.am || die
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable dsp)
		$(use_with alsa)
		$(use_with pulseaudio pulse)
	)
	use dsp && append-cxxflags '-DTGVOIP_USE_DESKTOP_DSP_BUNDLED'
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
