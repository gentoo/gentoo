# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.6
inherit netsurf

DESCRIPTION="framebuffer abstraction library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libnsfb/"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc"
IUSE="sdl test vnc wayland xcb"

RDEPEND="sdl? ( >=media-libs/libsdl-1.2.15-r4[static-libs?,${MULTILIB_USEDEP}] )
	vnc? ( >=net-libs/libvncserver-0.9.9-r2[static-libs?,${MULTILIB_USEDEP}] )
	wayland? ( >=dev-libs/wayland-1.0.6[static-libs?,${MULTILIB_USEDEP}] )
	xcb? ( >=x11-libs/libxcb-1.9.1[static-libs?,${MULTILIB_USEDEP}]
		>=x11-libs/xcb-util-0.3.9-r1[static-libs?,${MULTILIB_USEDEP}]
		>=x11-libs/xcb-util-image-0.3.9-r1[static-libs?,${MULTILIB_USEDEP}]
		>=x11-libs/xcb-util-keysyms-0.3.9-r1[static-libs?,${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.1.0-autodetect.patch )

DOCS=( usage )

src_configure() {
	netsurf_src_configure

	netsurf_makeconf+=(
		WITH_VNC=$(usex vnc)
		WITH_SDL=$(usex sdl)
		WITH_XCB=$(usex xcb)
		WITH_WLD=$(usex wayland)
	)
}
