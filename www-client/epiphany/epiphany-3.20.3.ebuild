# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 virtualx

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://wiki.gnome.org/Apps/Web"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~sparc x86"

COMMON_DEPEND="
	>=app-crypt/gcr-3.5.5:=
	>=app-crypt/libsecret-0.14
	>=app-text/iso-codes-0.35
	>=dev-libs/glib-2.44.0:2[dbus]
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=net-dns/avahi-0.6.22[dbus]
	>=net-libs/webkit-gtk-2.11.4:4=
	>=net-libs/libsoup-2.48:2.4
	>=x11-libs/gtk+-3.19.1:3
	>=x11-libs/libnotify-0.5.1:=
	gnome-base/gnome-desktop:3=

	dev-db/sqlite:3
	x11-libs/libwnck:3
	x11-libs/libX11
"
# epiphany-extensions support was removed in 3.7; let's not pretend it still works
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
	!www-client/epiphany-extensions
"
# paxctl needed for bug #407085
# eautoreconf requires gnome-common-3.5.5
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	dev-util/itstool
	sys-apps/paxctl
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# https://bugzilla.gnome.org/show_bug.cgi?id=751591
	"${FILESDIR}"/${PN}-3.16.0-unittest-1.patch

	# https://bugzilla.gnome.org/show_bug.cgi?id=751593
	"${FILESDIR}"/${PN}-3.14.0-unittest-2.patch
)

src_configure() {
	# Many years have passed since gecko based epiphany went away,
	# hence, stop relying on nss for migrating from that versions.
	gnome2_src_configure \
		--disable-nss \
		--enable-shared \
		--disable-static \
		--with-distributor-name=Gentoo \
		$(use_enable test tests)
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx emake check
}
