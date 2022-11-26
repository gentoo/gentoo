# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org meson xdg

DESCRIPTION="Font viewer utility for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-font-viewer"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-libs/glib-2.56.0:2
	>=gui-libs/gtk-4.5.0:4
	>=gui-libs/libadwaita-1.2.0:1=
	>=media-libs/harfbuzz-0.9.9:=
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	gnome-base/gnome-desktop:4=
	dev-libs/fribidi
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
