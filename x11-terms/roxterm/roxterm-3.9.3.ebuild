# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="A terminal emulator designed to integrate with the ROX environment"
HOMEPAGE="https://github.com/realh/roxterm"
SRC_URI="https://github.com/realh/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-3"
SLOT="1"
KEYWORDS="~amd64 x86"

RDEPEND="dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libpcre2
	sys-apps/dbus
	x11-libs/gtk+:3
	x11-libs/vte:2.91[vanilla]"
# vanilla vte due to https://github.com/realh/roxterm/issues/222
DEPEND="${RDEPEND}
	dev-libs/libxslt"
BDEPEND="virtual/pkgconfig"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
