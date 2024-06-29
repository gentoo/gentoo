# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Fast neofetch-like system information tool"
HOMEPAGE="https://github.com/fastfetch-cli/fastfetch"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fastfetch-cli/fastfetch.git"
	[[ ${PV} == *0.1.9999 ]] && EGIT_BRANCH=master
	[[ ${PV} == *0.2.9999 ]] && EGIT_BRANCH=dev
	[[ "${EGIT_BRANCH}" == "" ]] && die "Please set a git branch"
else
	SRC_URI="https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~loong ~mips ~ppc ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="MIT nvidia-gpu? ( NVIDIA-NVLM )"
SLOT="0"
IUSE="X chafa dbus ddcutil drm gnome imagemagick networkmanager nvidia-gpu opencl opengl osmesa pulseaudio sqlite test vulkan wayland xcb xfce xrandr"
RESTRICT="!test? ( test )"

# note - qa-vdb will always report errors because fastfetch loads the libs dynamically
# make sure to crank yyjson minimum version to match bundled version
RDEPEND="
	>=dev-libs/yyjson-0.9.0
	sys-libs/zlib
	X? ( x11-libs/libX11 )
	chafa? ( media-gfx/chafa )
	dbus? ( sys-apps/dbus )
	ddcutil? ( app-misc/ddcutil:= )
	drm? ( x11-libs/libdrm )
	gnome? (
		dev-libs/glib
		gnome-base/dconf
	)
	imagemagick? ( media-gfx/imagemagick:= )
	networkmanager? ( net-misc/networkmanager )
	opencl? ( virtual/opencl )
	opengl? ( media-libs/libglvnd[X] )
	osmesa? ( media-libs/mesa[osmesa] )
	pulseaudio? ( media-libs/libpulse )
	sqlite? ( dev-db/sqlite:3 )
	vulkan? (
		media-libs/vulkan-loader
		sys-apps/pciutils
	)
	wayland? ( dev-libs/wayland )
	xcb? ( x11-libs/libxcb )
	xfce? ( xfce-base/xfconf )
	xrandr? ( x11-libs/libXrandr )
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="
	xrandr? ( X )
	chafa? ( imagemagick )
"

src_configure() {
	local fastfetch_enable_imagemagick7=no
	local fastfetch_enable_imagemagick6=no
	if use imagemagick; then
		fastfetch_enable_imagemagick7=$(has_version '>=media-gfx/imagemagick-7.0.0' && echo yes || echo no)
		fastfetch_enable_imagemagick6=$(has_version '<media-gfx/imagemagick-7.0.0' && echo yes || echo no)
	fi

	local mycmakeargs=(
		-DENABLE_RPM=no
		-DENABLE_ZLIB=yes
		-DENABLE_SYSTEM_YYJSON=yes
		-DIS_MUSL=$(usex elibc_musl)

		-DENABLE_CHAFA=$(usex chafa)
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_DCONF=$(usex gnome)
		-DENABLE_DDCUTIL=$(usex ddcutil)
		-DENABLE_DRM=$(usex drm)
		-DENABLE_EGL=$(usex opengl)
		-DENABLE_GIO=$(usex gnome)
		-DENABLE_GLX=$(usex opengl)
		-DENABLE_IMAGEMAGICK6=${fastfetch_enable_imagemagick6}
		-DENABLE_IMAGEMAGICK7=${fastfetch_enable_imagemagick7}
		-DENABLE_LIBNM=$(usex networkmanager)
		-DENABLE_PROPRIETARY_GPU_DRIVER_API=$(usex nvidia-gpu)
		-DENABLE_OPENCL=$(usex opencl)
		-DENABLE_OSMESA=$(usex osmesa)
		-DENABLE_PULSE=$(usex pulseaudio)
		-DENABLE_SQLITE3=$(usex sqlite)
		-DENABLE_VULKAN=$(usex vulkan)
		-DENABLE_WAYLAND=$(usex wayland)
		-DENABLE_X11=$(usex X)
		-DENABLE_XCB=$(usex xcb)
		-DENABLE_XCB_RANDR=$(usex xcb)
		-DENABLE_XFCONF=$(usex xfce)
		-DENABLE_XRANDR=$(usex xrandr)
		-DBUILD_TESTS=$(usex test)
	)

	append-cppflags -DNDEBUG

	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm -r "${ED}"/usr/share/licenses || die
}
