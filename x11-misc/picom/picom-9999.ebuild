# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 meson xdg

DESCRIPTION="A lightweight compositor for X11 (previously a compton fork)"
HOMEPAGE="https://github.com/yshui/picom"
EGIT_REPO_URI="https://github.com/yshui/picom.git"

LICENSE="MPL-2.0 MIT"
SLOT="0"
KEYWORDS=""
IUSE="+config-file dbus +doc +drm opengl pcre"

RDEPEND="dev-libs/libev
	dev-libs/uthash
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXext
	x11-libs/pixman
	x11-libs/xcb-util-image
	x11-libs/xcb-util-renderutil
	config-file? (
		dev-libs/libconfig
		dev-libs/libxdg-basedir
	)
	dbus? ( sys-apps/dbus )
	drm? ( x11-libs/libdrm )
	opengl? ( virtual/opengl )
	pcre? ( dev-libs/libpcre )
	!x11-misc/compton"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig
	doc? ( app-text/asciidoc )"

src_configure() {
	local emesonargs=(
		$(meson_use config-file config_file)
		$(meson_use dbus)
		$(meson_use doc with_docs)
		$(meson_use opengl)
		$(meson_use pcre regex)
	)

	meson_src_configure

}
