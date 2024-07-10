# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sidplay2 fork with resid-fp"
HOMEPAGE="https://sourceforge.net/projects/sidplay-residfp/"
SRC_URI="https://downloads.sourceforge.net/sidplay-residfp/${PN}/$(ver_cut 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+alsa oss pulseaudio"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	media-libs/libsidplayfp
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-libs/libpulse )"
DEPEND="${RDEPEND}
	media-plugins/mpg123-output-plugins
	oss? ( virtual/os-headers )"

DOCS=( AUTHORS README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.4-musl-limits.patch
)

src_prepare() {
	default

	if ! use alsa; then
		sed -i -e 's:alsa >= 1.0:dIsAbLe&:' configure || die
	fi

	if ! use pulseaudio; then
		sed -i -e 's:libpulse-simple >= 1.0:dIsAbLe&:' configure || die
	fi
}

src_configure() {
	export ac_cv_header_linux_soundcard_h=$(usex oss)

	econf
}
