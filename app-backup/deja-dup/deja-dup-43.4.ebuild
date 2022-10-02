# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

# deja-dup can not recognize duplicity-1.0.0 and throws an error
# https://gitlab.gnome.org/World/deja-dup/-/issues/334
DEPEND="
	>=gui-libs/libadwaita-1.0:1
	>=dev-libs/glib-2.70.0:2
	>=dev-libs/libgpg-error-1.33
	>=gui-libs/gtk-4.6:4
	>=dev-libs/json-glib-1.2
	>=dev-libs/glib-2.64:2[dbus]
	>=app-crypt/libsecret-0.18.6[vala]
	>=net-libs/libsoup-3.0:3
	>=app-backup/duplicity-0.8.21
	<app-backup/duplicity-1.0.0
"

RDEPEND="${DEPEND}
	gnome-base/dconf
	gnome-base/gvfs[fuse]
"

src_prepare() {
	default
	vala_setup
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
