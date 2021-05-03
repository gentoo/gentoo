# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

TG_OWT_COMMIT="18cb4cd9bb4c2f5f5f5e760ec808f74c302bc1bf"
LIBYUV_COMMIT="ad890067f661dc747a975bc55ba3767fe30d4452"

DESCRIPTION="WebRTC build for Telegram"
HOMEPAGE="https://github.com/desktop-app/tg_owt"
SRC_URI="https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://archive.org/download/libyuv-${LIBYUV_COMMIT}.tar/libyuv-${LIBYUV_COMMIT}.tar.gz"
# Fetch libyuv archive from: https://chromium.googlesource.com/libyuv/libyuv/+archive/${LIBYUV_COMMIT}.tar.gz

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

# Bundled libs:
# - libyuv (no stable versioning, www-client/chromium and media-libs/libvpx bundle it)
# - libsrtp (project uses private APIs)
# - pffft (no stable versioning, patched)
# media-libs/libjpeg-turbo is required for libyuv
DEPEND="
	dev-cpp/abseil-cpp:=[cxx17(+)]
	dev-libs/libevent:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	media-libs/libjpeg-turbo:=
	>=media-libs/libvpx-1.10.0:=
	media-libs/openh264:=
	media-libs/opus
	media-video/ffmpeg:=
	net-libs/usrsctp
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${TG_OWT_COMMIT}"

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}/src/third_party/libyuv" || die
	unpack "libyuv-${LIBYUV_COMMIT}.tar.gz"
}

src_prepare() {
	# https://github.com/desktop-app/tg_owt/pull/55
	eapply "${FILESDIR}/Allow-using-packaged-third_party.patch"

	# We aren't installing any third_party headers
	sed -i '/third_party\/libyuv/d' cmake/libyuv.cmake || die

	# libvpx source files aren't included in the repository
	sed -i '/include(cmake\/libvpx.cmake)/d' CMakeLists.txt || die

	# Remove screen_drawer files that cause linking errors
	# (not used right now I don't think, maybe in a future version)
	# https://github.com/desktop-app/tg_owt/issues/58
	sed -i -e '/desktop_capture\/screen_drawer\.cc/d' \
		-e '/desktop_capture\/screen_drawer_lock_posix\.cc/d' CMakeLists.txt || die

	# HACK
	# build/headers don't have ppc64 condition and force SSE2.
	# sed it out and force C version on ppc64
	# without this linking tdesktop will fail with undef reference to `webrtc::VectorDifference_SSE2_W32
	if use ppc64; then
		sed -i 's/VectorDifference_SSE2_W.*/VectorDifference_C;/g' src/modules/desktop_capture/differ_block.cc || die
	fi

	cmake_src_prepare
}

src_configure() {
	# Defined by -DCMAKE_BUILD_TYPE=Release, avoids crashes
	# see https://bugs.gentoo.org/754012
	append-cppflags '-DNDEBUG'
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Save about 15MB of useless headers
	rm -r "${ED}/usr/include/tg_owt/third_party" || die
}
