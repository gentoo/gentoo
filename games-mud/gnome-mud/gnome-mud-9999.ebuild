# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_EAUTORECONF="yes"

inherit gnome2-utils git-r3 meson xdg

DESCRIPTION="GNOME MUD client"
HOMEPAGE="https://wiki.gnome.org/Apps/GnomeMud"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gnome-mud.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="debug gstreamer"

RDEPEND="
	>=dev-libs/glib-2.48:2
	>=x11-libs/gtk+-3.22:3
	>=x11-libs/vte-0.37:2.91
	dev-libs/libpcre
	sys-libs/zlib
	gstreamer? ( media-libs/gstreamer:1.0 )"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		-Dmccp=enabled
		-Dgstreamer=$(usex gstreamer enabled disabled)
		$(meson_use debug debug-logger)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
	gnome2_schemas_update
}
