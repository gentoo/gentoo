# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )
inherit gnome.org gnome2-utils meson python-any-r1 xdg

DESCRIPTION="Beat the odds in a poker-style dice game"
HOMEPAGE="https://wiki.gnome.org/Apps/Tali"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="
	dev-libs/glib:2
	>=x11-libs/gtk+-3.16:3
	dev-libs/libgnome-games-support:1=
"
RDEPEND="${DEPEND}
	>=gnome-base/librsvg-2.32:2
"
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
