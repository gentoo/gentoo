# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.40"

inherit gnome.org meson vala xdg

DESCRIPTION="Library for code common to GNOME games"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libgnome-games-support"

LICENSE="LGPL-3+"
SLOT="1/3"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

# glib dep in meson is 2.40, but vala is passed 2.44 target
RDEPEND="
	>=dev-libs/libgee-0.14.0:0.8=
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.19.2:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
"

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
}
