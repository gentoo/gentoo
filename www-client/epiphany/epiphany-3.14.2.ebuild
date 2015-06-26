# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/epiphany/epiphany-3.14.2.ebuild,v 1.4 2015/06/26 09:24:00 ago Exp $

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 pax-utils versionator virtualx

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://wiki.gnome.org/Apps/Web"

# TODO: coverage
LICENSE="GPL-2"
SLOT="0"
IUSE="+jit +nss test"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

COMMON_DEPEND="
	>=app-crypt/gcr-3.5.5
	>=app-crypt/libsecret-0.14
	>=app-text/iso-codes-0.35
	>=dev-libs/glib-2.38:2
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	>=gnome-base/gsettings-desktop-schemas-0.0.1
	>=net-dns/avahi-0.6.22[dbus]
	>=net-libs/webkit-gtk-2.5.90:4[jit?]
	>=net-libs/libsoup-2.48:2.4
	>=x11-libs/gtk+-3.13:3
	>=x11-libs/libnotify-0.5.1:=
	gnome-base/gnome-desktop:3=

	dev-db/sqlite:3
	x11-libs/libwnck:3
	x11-libs/libX11

	x11-themes/gnome-icon-theme
	x11-themes/gnome-icon-theme-symbolic

	nss? ( dev-libs/nss )
"
# epiphany-extensions support was removed in 3.7; let's not pretend it still works
RDEPEND="${COMMON_DEPEND}
	!www-client/epiphany-extensions
"
# paxctl needed for bug #407085
# eautoreconf requires gnome-common-3.5.5
DEPEND="${COMMON_DEPEND}
	>=gnome-base/gnome-common-3.6
	>=dev-util/intltool-0.50
	sys-apps/paxctl
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	# Fix missing symbol in webextension.so, bug #728972
	epatch "${FILESDIR}"/${PN}-3.14.0-missing-symbol.patch

	# Fix unittests
	epatch "${FILESDIR}"/${PN}-3.14.0-unittest-*.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--enable-shared \
		--disable-static \
		--with-distributor-name=Gentoo \
		$(use_enable nss) \
		$(use_enable test tests) \
		ITSTOOL=$(type -P true)
}

src_compile() {
	# needed to avoid "Command line `dbus-launch ...' exited with non-zero exit status 1"
	unset DISPLAY
	gnome2_src_compile
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	unset DISPLAY
	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check
}

src_install() {
	DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README TODO"
	gnome2_src_install
	use jit && pax-mark m "${ED}usr/bin/epiphany"
}
