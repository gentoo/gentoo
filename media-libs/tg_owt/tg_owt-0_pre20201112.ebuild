# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

TG_OWT_COMMIT="10b988aa9111fd25358443ac34d0d422b5108029"

DESCRIPTION="WebRTC build for Telegram"
HOMEPAGE="https://github.com/desktop-app/tg_owt"
SRC_URI="https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64"
IUSE="pulseaudio"

# some things from this list are bundled
# work on unbundling in progress
DEPEND="
	dev-libs/openssl:=
	dev-libs/protobuf:=
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
	# lacks nop, can't restore toc
	append-flags '-fPIC'
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=TRUE
		-DTG_OWT_PACKAGED_BUILD=TRUE
		-DTG_OWT_USE_PROTOBUF=TRUE
	)
	cmake_src_configure
}
