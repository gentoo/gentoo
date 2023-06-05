# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Cut, copy, and paste anything in your terminal"
HOMEPAGE="https://getclipboard.app/ https://github.com/Slackadays/Clipboard"
SRC_URI="https://github.com/Slackadays/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

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

pkg_postinst() {
	ewarn "The new history feature makes CB incompatible with how older versions stored clipboard contents."
	ewarn "If you have existing content when you upgrade, then it might not appear in CB, although it won't be deleted."
	ewarn "To fix this, take everything stored in the data folder of your existing clipboards"
	ewarn "and move them to a \"0\" subfolder within data."
	ewarn "So, if you have the file Foobar stored under data, the new setup will look like the folder 0 under data,"
	ewarn "and 0 stores the file Foobar."
	ewarn "To find where CB keeps your clipboards, use the cb info command and check the line that says Stored in...."
	ewarn "If you don't already have content stored with CB, then this warning doesn't apply to you."
}
