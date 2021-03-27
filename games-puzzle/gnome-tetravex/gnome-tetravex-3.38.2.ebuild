# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.40"

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Complete the puzzle by matching numbered tiles"
HOMEPAGE="https://wiki.gnome.org/Apps/Tetravex"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="cli +gui"
REQUIRED_USE="|| ( cli gui )"

RDEPEND="
	>=dev-libs/glib-2.42.0:2
	gui? ( >=x11-libs/gtk+-3.22.23:3 )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	gui? ( dev-util/itstool )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_prepare() {
	xdg_src_prepare
	vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use cli build_cli)
		$(meson_use gui build_gui)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
