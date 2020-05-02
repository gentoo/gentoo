# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

EGIT_COMMIT="a045c9eea47b371c0c514c72c76172a211c894cb"

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
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable dsp)
		$(use_with alsa)
		$(use_with pulseaudio pulse)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
