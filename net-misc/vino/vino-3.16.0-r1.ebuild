# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"

inherit eutils gnome2

DESCRIPTION="An integrated VNC server for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Vino"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="crypt gnome-keyring ipv6 jpeg ssl +telepathy zeroconf +zlib"
# bug #394611; tight encoding requires zlib encoding
REQUIRED_USE="jpeg? ( zlib )"

# cairo used in vino-fb
# libSM and libICE used in eggsmclient-xsmp
RDEPEND="
	>=dev-libs/glib-2.26:2
	>=dev-libs/libgcrypt-1.1.90:0=
	>=x11-libs/gtk+-3:3

	dev-libs/dbus-glib
	x11-libs/cairo:=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXtst
	x11-libs/pango[X]

	>=x11-libs/libnotify-0.7.0:=

	crypt? ( >=dev-libs/libgcrypt-1.1.90:0= )
	gnome-keyring? ( app-crypt/libsecret )
	jpeg? ( virtual/jpeg:0= )
	ssl? ( >=net-libs/gnutls-2.2.0:= )
	telepathy? ( >=net-libs/telepathy-glib-0.18 )
	zeroconf? ( >=net-dns/avahi-0.6:=[dbus] )
	zlib? ( sys-libs/zlib:= )
"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=dev-util/intltool-0.50
	virtual/pkgconfig
	app-crypt/libsecret
"
# libsecret is always required at build time per bug 322763

src_prepare() {
	# Improve handling of name resolution failure (from 'master')
	epatch "${FILESDIR}"/${P}-name-resolution.patch

	# Avoid a crash when showing the preferences (from 'master')
	epatch "${FILESDIR}"/${P}-fix-crash.patch

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--with-gcrypt \
		$(use_enable ipv6) \
		$(use_with crypt gcrypt) \
		$(use_with gnome-keyring secret) \
		$(use_with jpeg) \
		$(use_with ssl gnutls) \
		$(use_with telepathy) \
		$(use_with zeroconf avahi) \
		$(use_with zlib)
}
