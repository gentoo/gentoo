# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic autotools

DESCRIPTION="VoIP library for Telegram clients"
HOMEPAGE="https://github.com/telegramdesktop/libtgvoip"

LIBTGVOIP_COMMIT="2cffda6222f07cd7d0aa4627a06fa99b05a3956d"
SRC_URI="https://github.com/telegramdesktop/libtgvoip/archive/${LIBTGVOIP_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${LIBTGVOIP_COMMIT}"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv"
IUSE="+dsp +alsa pulseaudio"

DEPEND="
	dev-libs/openssl:=
	media-libs/opus
	alsa? ( media-libs/alsa-lib )
	dsp? ( media-libs/tg_owt:= )
	pulseaudio? ( media-sound/pulseaudio )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
REQUIRED_USE="
	|| ( alsa pulseaudio )
"

src_prepare() {
	# Will be controlled by us
	sed -i -e '/^CFLAGS += -DTGVOIP_NO_DSP/d' Makefile.am || die
	# https://bugs.gentoo.org/717210
	echo 'libtgvoip_la_LIBTOOLFLAGS = --tag=CXX' >> Makefile.am || die
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-dsp  # WebRTC is linked from tg_owt
		$(use_with alsa)
		$(use_with pulseaudio pulse)
	)
	if use dsp; then
		append-cppflags "-I${ESYSROOT}/usr/include/tg_owt"
		append-cppflags "-I${ESYSROOT}/usr/include/tg_owt/third_party/abseil-cpp"
		append-libs '-ltg_owt'
	else
		append-cppflags '-DTGVOIP_NO_DSP'
	fi
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
