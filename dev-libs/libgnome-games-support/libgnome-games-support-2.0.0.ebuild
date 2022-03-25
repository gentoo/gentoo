# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson vala xdg

DESCRIPTION="Library for code common to GNOME games"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libgnome-games-support"

LICENSE="LGPL-3+"
SLOT="2/4"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

# glib dep in meson is 2.40, but vala is passed 2.44 target
RDEPEND="
	>=dev-libs/libgee-0.14.0:0.8=
	>=dev-libs/glib-2.44:2
	>=gui-libs/gtk-4.2:4
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
"

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}
