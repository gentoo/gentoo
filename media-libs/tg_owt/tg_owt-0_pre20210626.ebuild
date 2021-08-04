# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="WebRTC build for Telegram"
HOMEPAGE="https://github.com/desktop-app/tg_owt"

TG_OWT_COMMIT="91d836dc84a16584c6ac52b36c04c0de504d9c34"
LIBYUV_COMMIT="ad890067f661dc747a975bc55ba3767fe30d4452"
SRC_URI="https://github.com/desktop-app/tg_owt/archive/${TG_OWT_COMMIT}.tar.gz -> ${P}.tar.gz
	https://archive.org/download/libyuv-${LIBYUV_COMMIT}.tar/libyuv-${LIBYUV_COMMIT}.tar.gz"
S="${WORKDIR}/${PN}-${TG_OWT_COMMIT}"
# Fetch libyuv archive from: https://chromium.googlesource.com/libyuv/libyuv/+archive/${LIBYUV_COMMIT}.tar.gz

LICENSE="BSD"
SLOT="0/${PV##*pre}"
KEYWORDS="amd64 ~ppc64"
IUSE="+alsa pulseaudio screencast +X"
REQUIRED_USE="pulseaudio? ( alsa )"

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
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	screencast? (
		dev-libs/glib:2
		media-video/pipewire:=
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
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/tg_owt-0_pre20210626-allow-disabling-pipewire.patch"
	"${FILESDIR}/tg_owt-0_pre20210626-allow-disabling-X11.patch"
	"${FILESDIR}/tg_owt-0_pre20210626-allow-disabling-pulseaudio.patch"
	"${FILESDIR}/tg_owt-0_pre20210626-expose-set_allow_pipewire.patch"
)

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}/src/third_party/libyuv" || die
	unpack "libyuv-${LIBYUV_COMMIT}.tar.gz"
}

src_prepare() {
	# libvpx source files aren't included in the repository
	sed -i '/include(cmake\/libvpx.cmake)/d' CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	# Defined by -DCMAKE_BUILD_TYPE=Release, avoids crashes
	# see https://bugs.gentoo.org/754012
	append-cppflags '-DNDEBUG'

	local mycmakeargs=(
		-DTG_OWT_USE_X11=$(usex X ON OFF)
		-DTG_OWT_USE_PIPEWIRE=$(usex screencast ON OFF)
		-DTG_OWT_BUILD_AUDIO_BACKENDS=$(usex alsa ON OFF)
		-DTG_OWT_BUILD_PULSE_BACKEND=$(usex pulseaudio ON OFF)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# Save about 15MB of useless headers
	rm -r "${ED}/usr/include/tg_owt/third_party" || die

	# Install third_party/libyuv anyway...
	dodir /usr/include/tg_owt/third_party/libyuv/include
	cd "${S}/src/third_party/libyuv/include"
	find -type f -name "*.h" -exec install -Dm644 '{}' "${ED}/usr/include/tg_owt/third_party/libyuv/include/{}" \;
}
