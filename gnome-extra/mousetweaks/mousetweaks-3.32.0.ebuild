# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Mouse accessibility enhancements for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Projects/Mousetweaks"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.25.9:2
	>=x11-libs/gtk+-3:3[X]
	>=gnome-base/gsettings-desktop-schemas-0.1

	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXfixes
	x11-libs/libXcursor
"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
