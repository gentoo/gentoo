# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Menubar, doc and app bundle integration for GTK+"
HOMEPAGE="https://wiki.gnome.org/Projects/GTK%2B/OSX/Integration"
SRC_URI="https://download.gnome.org/sources/${PN}/$(ver_cut 1-2)/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x64-macos"

DEPEND="
	>=dev-libs/glib-2.14.0
	x11-libs/gtk+:3[aqua]
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf --enable-python=no
}
