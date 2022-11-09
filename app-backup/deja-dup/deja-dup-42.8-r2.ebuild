# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson gnome2-utils vala xdg

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://wiki.gnome.org/Apps/DejaDup"
SRC_URI="https://gitlab.gnome.org/World/deja-dup/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	$(vala_depend)
	dev-util/intltool
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-libs/appstream-glib )
"

DEPEND="
	dev-libs/atk
	>=app-backup/duplicity-0.7.14
	>=app-crypt/libsecret-0.18.6[vala]
	>=dev-libs/glib-2.64:2[dbus]
	>=dev-libs/json-glib-1.2
	dev-libs/libgpg-error
	>=gui-libs/libhandy-1.0:1
	>=net-libs/libsoup-2.48:2.4
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
"

RDEPEND="${DEPEND}
	gnome-base/dconf
	gnome-base/gvfs[fuse]
"

src_prepare() {
	default
	vala_src_prepare
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
