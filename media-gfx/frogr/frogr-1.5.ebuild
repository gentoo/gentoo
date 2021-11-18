# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="flickr applications for GNOME"
HOMEPAGE="https://live.gnome.org/Frogr"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.44:2
	>=dev-libs/json-glib-1.2
	>=x11-libs/gtk+-3.16:3[introspection]
	>=media-libs/libexif-0.6.14
	>=dev-libs/libxml2-2.6.8:2
	media-libs/gstreamer:1.0
	>=net-libs/libsoup-2.34:2.4
	>=dev-libs/libgcrypt-1.5:*
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.19.7
	virtual/pkgconfig
"
# TODO add a useflag for enable-video or header-bar???

PATCHES=(
	"${FILESDIR}/frogr-1.5-warning-level.patch"
)

src_configure() {
	local emesonargs=(
		# bug #714132
		-Dwerror=false
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_pkg_postrm
	gnome2_schemas_update
}
