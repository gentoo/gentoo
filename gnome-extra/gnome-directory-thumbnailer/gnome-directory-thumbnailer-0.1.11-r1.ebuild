# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2

DESCRIPTION="Thumbnail generator for directories"
HOMEPAGE="https://wiki.gnome.org/Projects/GnomeDirectoryThumbnailer"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=(
	"${FILESDIR}"/${PV}-Update-for-gnome-desktop-43-API-change.patch
)

RDEPEND="
	>=dev-libs/glib-2.35:2
	>=x11-libs/gdk-pixbuf-2.36.5:2
	>=gnome-base/gnome-desktop-2.2:3=
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"
