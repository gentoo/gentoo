# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Remember anything, anytime, anywhere... "
HOMEPAGE="https://getclipboard.app/ https://github.com/Slackadays/Clipboard"
SRC_URI="https://github.com/Slackadays/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+X wayland lto debug"

REQUIRED_USE=" || ( X wayland )"

RDEPEND="X? ( x11-libs/libX11 )
		wayland? ( dev-libs/wayland-protocols
					dev-libs/wayland
				)
"
PATCHES=( "${FILESDIR}/${P}-libdestination-and-disable-git-patch.patch" )

src_prepare() {
	if ! use X; then
		eapply "${FILESDIR}/${P}-disable-x11.patch"
	elif ! use wayland; then
		eapply "${FILESDIR}/${P}-disable-wayland.patch"
	fi

	if ! use lto; then
		eapply "${FILESDIR}/${P}-disable-lto.patch"
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
	"-DCMAKE_INSTALL_LIBDIR=$(get_libdir)"
	)
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CFLAGS+=" -DNDEBUG"
		CXXFLAGS+=" -DNDEBUG"
	fi
	cmake_src_configure
}

pkg_postinst() {
	elog "The \"clipboard\" command is depreciated.  Use \"cb\" instead.  \"cb\" is symlinked to \"clipboard\" for now."
}
