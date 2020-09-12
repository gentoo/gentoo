# Copyright 1999-2020 Gentoo Authors
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
	x11-libs/gtk+:3
	x11-libs/gdk-pixbuf:2
	dev-libs/glib:2
	dev-libs/libgnome-games-support:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/${P}-fnocommon.patch"
)
