# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="WebRTC build for Telegram"
HOMEPAGE="https://github.com/desktop-app/tg_owt"

TG_OWT_COMMIT="232ec410502e773024e8d83cfae83a52203306c0"
LIBYUV_COMMIT="04821d1e7d60845525e8db55c7bcd41ef5be9406"
LIBSRTP_COMMIT="a566a9cfcd619e8327784aa7cff4a1276dc1e895"
SRC_URI="https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://gitlab.com/chromiumsrc/libyuv/-/archive/${LIBYUV_COMMIT}/libyuv-${LIBYUV_COMMIT}.tar.bz2"
S="${WORKDIR}/${PN}-${TG_OWT_COMMIT}"
# Upstream libyuv: https://chromium.googlesource.com/libyuv/libyuv

LICENSE="BSD"
SLOT="0/${PV##*pre}"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv"
IUSE="screencast +X"

# This package's USE flags may change the ABI and require a rebuild of
#  dependent pacakges. As such, one should make sure to depend on
#  media-libs/tg_owt[x=,y=,z=] for any package that uses this.
# Furthermore, the -DNDEBUG preprocessor flag should be defined by any
#  dependent package, failure to do so will change the ABI in the header files.

# Bundled libs:
# - libyuv (no stable versioning, www-client/chromium and media-libs/libvpx bundle it)
# - pffft (no stable versioning, patched)
RDEPEND="
	>=dev-cpp/abseil-cpp-20240722.0:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
	media-libs/libjpeg-turbo:=
	>=media-libs/libvpx-1.10.0:=
	media-libs/openh264:=
	media-libs/opus
	media-video/ffmpeg:=
	net-libs/libsrtp:2=
	dev-libs/crc32c
	screencast? (
		dev-libs/glib:2
		>=media-video/pipewire-1.0.7:=
	)
	X? (
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXrender
		x11-libs/libXrandr
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	screencast? (
		media-libs/libglvnd[X]
		media-libs/mesa
		x11-libs/libdrm
	)
"
BDEPEND="
	virtual/pkgconfig
	X? ( x11-base/xorg-proto )
"

src_unpack() {
	default

	mv -T "libyuv-${LIBYUV_COMMIT}" "${S}/src/third_party/libyuv" || die
}

src_prepare() {
	# The sources for these aren't available, avoid needing them
	sed -e '/include(cmake\/libcrc32c.cmake)/d' \
		-e '/include(cmake\/libabsl.cmake)/d' -i CMakeLists.txt || die

	# "lol" said the scorpion, "lmao"
	sed -i '/if (BUILD_SHARED_LIBS)/{n;n;s/WARNING/DEBUG/}' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Defined by -DCMAKE_BUILD_TYPE=Release, avoids crashes
	# See https://bugs.gentoo.org/754012
	# EAPI 8 still wipes this flag.
	append-cppflags '-DNDEBUG'

	local mycmakeargs=(
		-DTG_OWT_USE_X11=$(usex X)
		-DTG_OWT_USE_PIPEWIRE=$(usex screencast)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Save about 15MB of useless headers
	rm -r "${ED}/usr/include/tg_owt/rtc_base/third_party" || die
	rm -r "${ED}/usr/include/tg_owt/common_audio/third_party" || die
	rm -r "${ED}/usr/include/tg_owt/modules/third_party" || die
	rm -r "${ED}/usr/include/tg_owt/third_party" || die

	# Install a few headers anyway, as required by net-im/telegram-desktop...
	local headers=(
		third_party/libyuv/include
		rtc_base/third_party/sigslot
		rtc_base/third_party/base64
	)
	for dir in "${headers[@]}"; do
		pushd "${S}/src/${dir}" > /dev/null || die
		find -type f -name "*.h" -exec install -Dm644 '{}' "${ED}/usr/include/tg_owt/${dir}/{}" \; || die
		popd > /dev/null || die
	done
}
