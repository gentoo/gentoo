# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome.org meson xdg

DESCRIPTION="Mind game - build molecules out of single atoms"
HOMEPAGE="https://wiki.gnome.org/Apps/Atomix"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=x11-libs/gtk+-3.10:3
	>=x11-libs/gdk-pixbuf-2.0.5:2
	>=dev-libs/glib-2.36.0:2
	dev-libs/libgnome-games-support:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
