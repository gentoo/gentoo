# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="Clipboard"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Cut, copy, and paste anything in your terminal"
HOMEPAGE="https://getclipboard.app/ https://github.com/Slackadays/Clipboard"
SRC_URI="https://github.com/Slackadays/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X wayland lto debug"

RDEPEND="X? ( x11-libs/libX11 )
		wayland? (
			dev-libs/wayland-protocols
			dev-libs/wayland
		)
"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/disable-git-and-lto.patch"
)

src_prepare() {
	if ! use wayland; then
		sed -i '/pkg_check_modules(WAYLAND_CLIENT wayland-client wayland-protocols)/d' CMakeLists.txt || die
	fi

	if ! use debug; then
		eapply "${FILESDIR}/disable-debug-info.patch"
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
	"-DCMAKE_INSTALL_LIBDIR=$(get_libdir)"
	"-DCMAKE_INTERPROCEDURAL_OPTIMIZATION=$(usex lto TRUE FALSE)"
	"-DCMAKE_DISABLE_FIND_PACKAGE_X11=$(usex X OFF ON)"
	)
	cmake_src_configure
}
