# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit meson xdg

DESCRIPTION="Lightweight, graphical wifi management utility for Linux"
HOMEPAGE="https://github.com/J-Lentz/iwgtk"
SRC_URI="https://github.com/J-Lentz/iwgtk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="app-text/scdoc"

DEPEND="
	app-accessibility/at-spi2-core:2
	dev-libs/glib:2
	gui-libs/gtk:4
	media-gfx/qrencode:=
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/pango:0
"

RDEPEND="
	${DEPEND}
	>=net-wireless/iwd-1.28
"
