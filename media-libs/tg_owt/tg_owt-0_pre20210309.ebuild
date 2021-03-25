# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

TG_OWT_COMMIT="7f965710b93c4dadd7e6f1ac739e708694df7929"
LIBVPX_COMMIT="5b63f0f821e94f8072eb483014cfc33b05978bb9"
LIBYUV_COMMIT="ad890067f661dc747a975bc55ba3767fe30d4452"

DESCRIPTION="WebRTC build for Telegram"
HOMEPAGE="https://github.com/desktop-app/tg_owt"
SRC_URI="https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://github.com/webmproject/libvpx/archive/${LIBVPX_COMMIT}.tar.gz -> libvpx-${LIBVPX_COMMIT}.tar.gz
	https://archive.org/download/libyuv-${LIBYUV_COMMIT}.tar/libyuv-${LIBYUV_COMMIT}.tar.gz"
# Fetch libyuv archive from: https://chromium.googlesource.com/libyuv/libyuv/+archive/${LIBYUV_COMMIT}.tar.gz

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE="pulseaudio"

# Bundled libs:
# - libvpx (media-libs/libvpx, requires git version, post v1.9.0)
# - libyuv (no stable versioning)
# - libsrtp (project uses private APIs)
# - pffft (no stable versioning, patched)
# Bundled libs that will be unbundled at a later date (upstream support is in the works):
# - net-libs/usrsctp
# - dev-libs/libevent:=
# - dev-cpp/abseil-cpp
# - media-libs/openh264:=
# dev-lang/yasm is required for libvpx
# media-libs/libjpeg-turbo is required for libyuv
DEPEND="
	dev-libs/openssl:=
	dev-libs/protobuf:=
	media-libs/alsa-lib
	media-libs/libjpeg-turbo:=
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

src_unpack() {
	unpack "${P}.tar.gz"
	unpack "libvpx-${LIBVPX_COMMIT}.tar.gz"
	mv -T "libvpx-${LIBVPX_COMMIT}" "$S/src/third_party/libvpx/source/libvpx" || die
	cd "$S/src/third_party/libyuv" || die
	unpack "libyuv-${LIBYUV_COMMIT}.tar.gz"
}

src_prepare() {
	# Can cause race conditions when no webcam is available or webcam is blocked
	# See https://bugs.debian.org/982556
	sed -i -e 's/#ifndef NO_MAIN_THREAD_WRAPPING/#if 0/' src/rtc_base/thread.cc || die

	# Causes forced inclusion of SSE2, so we strip it out on x86* arches
	# https://github.com/desktop-app/tg_owt/pull/57
	if ! use amd64 && ! use x86; then
		sed -i '/modules\/desktop_capture/d' CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	# Defined by -DCMAKE_BUILD_TYPE=Release, avoids crashes
	# see https://bugs.gentoo.org/754012
	append-cppflags '-DNDEBUG'

	append-flags '-fPIC'
	cmake_src_configure
}
