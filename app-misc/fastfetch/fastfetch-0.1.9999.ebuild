# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Fast system information tool"
HOMEPAGE="https://github.com/fastfetch-cli/fastfetch"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fastfetch-cli/fastfetch.git"
	[[ ${PV} == *0.1.9999 ]] && EGIT_BRANCH=master
	[[ ${PV} == *0.2.9999 ]] && EGIT_BRANCH=dev
	[[ "${EGIT_BRANCH}" == "" ]] && die "Please set a git branch"
else
	SRC_URI="https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="X chafa dbus ddcutil gnome imagemagick networkmanager opencl opengl osmesa pci pulseaudio sqlite vulkan wayland xcb xfce xrandr"

# note - qa-vdb will always report errors because fastfetch loads the libs dynamically
RDEPEND="
	dev-libs/yyjson
	sys-libs/zlib
	X? ( x11-libs/libX11 )
	chafa? ( media-gfx/chafa )
	dbus? ( sys-apps/dbus )
	ddcutil? ( app-misc/ddcutil:= )
	gnome? (
		dev-libs/glib
		gnome-base/dconf
	)
	imagemagick? ( media-gfx/imagemagick:= )
	networkmanager? ( net-misc/networkmanager )
	opencl? ( virtual/opencl )
	opengl? ( media-libs/libglvnd[X] )
	osmesa? ( media-libs/mesa[osmesa] )
	pci? ( sys-apps/pciutils )
	pulseaudio? ( media-libs/libpulse )
	sqlite? ( dev-db/sqlite:3 )
	vulkan? ( media-libs/vulkan-loader )
	wayland? ( dev-libs/wayland )
	xcb? ( x11-libs/libxcb )
	xfce? ( xfce-base/xfconf )
	xrandr? ( x11-libs/libXrandr )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="
	xrandr? ( X )
	chafa? ( imagemagick )
"

PATCHES=( "${FILESDIR}"/${PN}-2.0.0-dont-fetch-yyjson.patch )

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

		-DENABLE_CHAFA=$(usex chafa)
		-DENABLE_DBUS=$(usex dbus)
		-DENABLE_DDCUTIL=$(usex ddcutil)
		-DENABLE_DCONF=$(usex gnome)
		-DENABLE_EGL=$(usex opengl)
		-DENABLE_GIO=$(usex gnome)
		-DENABLE_GLX=$(usex opengl)
		-DENABLE_IMAGEMAGICK6=${fastfetch_enable_imagemagick6}
		-DENABLE_IMAGEMAGICK7=${fastfetch_enable_imagemagick7}
		-DENABLE_LIBNM=$(usex networkmanager)
		-DENABLE_LIBPCI=$(usex pci)
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
	)

	append-cppflags -DNDEBUG

	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm -r "${ED}"/usr/share/licenses || die
}
