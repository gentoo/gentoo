# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit meson python-r1 xdg

DESCRIPTION="A lightweight compositor for X11 (previously a compton fork)"
HOMEPAGE="https://github.com/yshui/picom"
SRC_URI="https://github.com/yshui/picom/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+config-file dbus +doc +drm opengl pcre"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libev
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
	pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig
	doc? ( app-text/asciidoc )"

PATCHES=(
	"${FILESDIR}"/${P}-no_opengl.patch
	)

src_configure() {
	local emesonargs=(
		$(meson_use config-file config_file)
		$(meson_use dbus)
		$(meson_use doc build_docs)
		$(meson_use opengl)
		$(meson_use pcre regex)
	)

	meson_src_configure

}

src_install() {
	meson_src_install

	python_replicate_script "${ED}"/usr/bin/compton-convgen.py
}
