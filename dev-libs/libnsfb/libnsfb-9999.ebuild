# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit git-r3 netsurf

DESCRIPTION="C library for framebuffer abstraction"
HOMEPAGE="https://www.netsurf-browser.org/projects/libnsfb/"
EGIT_REPO_URI="git://git.netsurf-browser.org/${PN}.git"

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="sdl test vnc wayland X"

RESTRICT="!test? ( test )"

RDEPEND="sdl? ( >=media-libs/libsdl-1.2.15-r4 )
	vnc? ( >=net-libs/libvncserver-0.9.9-r2 )
	wayland? ( >=dev-libs/wayland-1.0.6 )
	X? (
		>=x11-libs/libxcb-1.9.1
		>=x11-libs/xcb-util-0.3.9-r1
		>=x11-libs/xcb-util-image-0.3.9-r1
		>=x11-libs/xcb-util-keysyms-0.3.9-r1
	)"
BDEPEND="dev-build/netsurf-buildsystem"

PATCHES=( "${FILESDIR}/${PN}-0.1.0-autodetect.patch" )

DOCS=( usage )

_emake() {
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared \
		WITH_VNC=$(usex vnc) \
		WITH_SDL=$(usex sdl) \
		WITH_XCB=$(usex X) \
		WITH_WLD=$(usex wayland) \
		$@
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${D}" install
}

src_test() {
	_emake test
}
