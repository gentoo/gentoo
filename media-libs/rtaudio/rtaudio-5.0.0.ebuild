# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ltprune autotools

DESCRIPTION="A set of cross-platform C++ classes for realtime audio I/O"
HOMEPAGE="https://www.music.mcgill.ca/~gary/rtaudio/"
SRC_URI="https://www.music.mcgill.ca/~gary/${PN}/release/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/6"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+alsa doc jack pulseaudio static-libs"
REQUIRED_USE="|| ( alsa jack pulseaudio )"

RDEPEND="alsa? ( media-libs/alsa-lib )
	jack? (
		media-libs/alsa-lib
		media-sound/jack-audio-connection-kit
	)
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1.2-cflags.patch
)

src_prepare() {
	default

	# don't rebuild docs
	export ac_cv_prog_DOXYGEN=

	eautoreconf
}

src_configure() {
	# OSS support requires OSSv4
	local myconf=(
		$(use_enable static-libs static)
		$(use_with jack)
		$(use_with alsa)
		$(use_with pulseaudio pulse)
		--without-oss
	)

	econf "${myconf[@]}"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc readme doc/release.txt
	if use doc; then
		dodoc -r doc/html
		dodoc -r doc/images
	fi

	prune_libtool_files
}
