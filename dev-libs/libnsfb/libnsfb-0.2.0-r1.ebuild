# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="framebuffer abstraction library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libnsfb/"
SRC_URI="https://download.netsurf-browser.org/libs/releases/${P}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc"
IUSE="sdl test vnc wayland xcb"

RDEPEND="sdl? ( >=media-libs/libsdl-1.2.15-r4 )
	vnc? ( >=net-libs/libvncserver-0.9.9-r2 )
	wayland? ( >=dev-libs/wayland-1.0.6 )
	xcb? (
		>=x11-libs/libxcb-1.9.1
		>=x11-libs/xcb-util-0.3.9-r1
		>=x11-libs/xcb-util-image-0.3.9-r1
		>=x11-libs/xcb-util-keysyms-0.3.9-r1
	)"
DEPEND="${RDEPEND}
	dev-util/netsurf-buildsystem"

PATCHES=( "${FILESDIR}"/${PN}-0.1.0-autodetect.patch )

DOCS=( usage )

_emake() {
	source /usr/share/netsurf-buildsystem/gentoo-helpers.sh
	netsurf_define_makeconf
	emake "${NETSURF_MAKECONF[@]}" COMPONENT_TYPE=lib-shared \
		WITH_VNC=$(usex vnc) \
		WITH_SDL=$(usex sdl) \
		WITH_XCB=$(usex xcb) \
		WITH_WLD=$(usex wayland) \
		$@
}

src_compile() {
	_emake
}

src_install() {
	_emake DESTDIR="${ED}" install
}
