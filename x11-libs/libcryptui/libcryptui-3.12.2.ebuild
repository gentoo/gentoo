# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="User interface components for OpenPGP"
HOMEPAGE="https://wiki.gnome.org/Apps/Seahorse"

LICENSE="GPL-2+ LGPL-2.1+ FDL-1.1"
SLOT="0"
IUSE="+introspection libnotify"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 x86 ~x86-fbsd"

# Pull in libnotify-0.7 because it's controlled via an automagic ifdef
COMMON_DEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3:3[introspection?]
	>=dev-libs/dbus-glib-0.72
	gnome-base/libgnome-keyring
	x11-libs/libICE
	x11-libs/libSM

	>=app-crypt/gpgme-1
	>=app-crypt/gnupg-1.4

	introspection? ( >=dev-libs/gobject-introspection-0.6.4:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
"
DEPEND="${COMMON_DEPEND}
	>=app-text/scrollkeeper-0.3
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	sys-devel/gettext
	virtual/pkgconfig
"
# Before 3.1.4, libcryptui was part of seahorse
RDEPEND="${COMMON_DEPEND}
	!<app-crypt/seahorse-3.1.4
"

src_prepare() {
	# Support GnuPG 2.1, https://bugzilla.gnome.org/show_bug.cgi?id=745843
	epatch "${FILESDIR}"/${PN}-3.12.2-gnupg-2.1.patch

	# FIXME: Do not mess with CFLAGS with USE="debug"
	sed -e '/CFLAGS="$CFLAGS -g -O0/d' \
		-e 's/-Werror//' \
		-i configure.ac configure || die "sed failed"

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--disable-update-mime-database \
		$(use_enable introspection) \
		$(use_enable libnotify)
}
