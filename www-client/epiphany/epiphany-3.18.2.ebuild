# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 virtualx

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://wiki.gnome.org/Apps/Web"

# TODO: coverage
LICENSE="GPL-2"
SLOT="0"
IUSE="nss test"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"

COMMON_DEPEND="
	>=app-crypt/gcr-3.5.5
	>=app-crypt/libsecret-0.14
	>=app-text/iso-codes-0.35
	>=dev-libs/glib-2.38:2[dbus]
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=net-dns/avahi-0.6.22[dbus]
	>=net-libs/webkit-gtk-2.9.5:4
	>=net-libs/libsoup-2.48:2.4
	>=x11-libs/gtk+-3.13:3
	>=x11-libs/libnotify-0.5.1:=
	gnome-base/gnome-desktop:3=

	dev-db/sqlite:3
	x11-libs/libwnck:3
	x11-libs/libX11

	x11-themes/adwaita-icon-theme

	nss? ( dev-libs/nss )
"
# epiphany-extensions support was removed in 3.7; let's not pretend it still works
RDEPEND="${COMMON_DEPEND}
	!www-client/epiphany-extensions
"
# paxctl needed for bug #407085
# eautoreconf requires gnome-common-3.5.5
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=gnome-base/gnome-common-3.6
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	dev-util/itstool
	sys-apps/paxctl
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# Fix unittests
	# https://bugzilla.gnome.org/show_bug.cgi?id=751591
	epatch "${FILESDIR}"/${PN}-3.16.0-unittest-1.patch

	# https://bugzilla.gnome.org/show_bug.cgi?id=751593
	epatch "${FILESDIR}"/${PN}-3.14.0-unittest-2.patch

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-shared \
		--disable-static \
		--with-distributor-name=Gentoo \
		$(use_enable nss) \
		$(use_enable test tests)
}

src_compile() {
	# needed to avoid "Command line `dbus-launch ...' exited with non-zero exit status 1"
	unset DISPLAY
	gnome2_src_compile
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	unset DISPLAY
	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check
}

src_install() {
	DOCS="AUTHORS ChangeLog* NEWS README TODO"
	gnome2_src_install
}
