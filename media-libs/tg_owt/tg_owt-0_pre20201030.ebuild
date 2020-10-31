# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

TG_OWT_COMMIT="1d4f7d74ff1a627db6e45682efd0e3b85738e426"

DESCRIPTION="WebRTC build for Telegram"
HOMEPAGE="https://github.com/desktop-app/tg_owt"
SRC_URI="https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="pulseaudio"

# some things from this list are bundled
# work on unbundling in progress
DEPEND="
	dev-libs/openssl:=
	media-libs/alsa-lib
	media-libs/libjpeg-turbo:=
	media-libs/libvpx:=
	media-libs/openh264:=
	media-libs/opus
	media-video/ffmpeg:=
	!pulseaudio? ( media-sound/apulse[sdk] )
	pulseaudio? ( media-sound/pulseaudio )
"

RDEPEND="${DEPEND}"

BDEPEND="
	virtual/pkgconfig
	amd64? ( dev-lang/yasm )
"

S="${WORKDIR}/${PN}-${TG_OWT_COMMIT}"

src_configure() {
	local mycmakeargs=(
		-DTG_OWT_PACKAGED_BUILD=TRUE
	)
	cmake_src_configure
}
