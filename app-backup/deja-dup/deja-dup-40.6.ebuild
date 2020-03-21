# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson eutils gnome2-utils vala xdg

DESCRIPTION="Simple backup tool using duplicity back-end"
HOMEPAGE="https://gitlab.gnome.org/World/deja-dup"
SRC_URI="https://gitlab.gnome.org/World/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="nautilus test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=app-crypt/libsecret-0.18.6[vala]
	>=dev-libs/glib-2.56:2[dbus]
	>=dev-libs/json-glib-1.2
	>=dev-libs/libpeas-1.0
	>=net-libs/libsoup-2.48
	>=x11-libs/gtk+-3.10:3
	>=x11-libs/libnotify-0.7

	>=app-backup/duplicity-0.7.14
	dev-libs/dbus-glib
	net-libs/gnome-online-accounts[vala]
	dev-libs/appstream-glib

	nautilus? ( gnome-base/nautilus )
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/dconf
	gnome-base/gvfs[fuse]
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-perl/Locale-gettext
	virtual/pkgconfig
	dev-util/intltool
	dev-util/itstool
	sys-devel/gettext
"

src_prepare() {
	vala_src_prepare
	eapply_user
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
