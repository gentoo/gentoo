# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="H.323 and SIP VoIP softphone"
HOMEPAGE="http://www.ekiga.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="dbus debug doc eds h323 ldap libnotify cpu_flags_x86_mmx pulseaudio +shm v4l xv zeroconf"

# gconf is a hard requirement until this bug is fixed:
# https://bugzilla.gnome.org/show_bug.cgi?id=721198
RDEPEND="
	>=dev-libs/glib-2.24.0:2
	>=dev-libs/boost-1.49:0=
	dev-libs/libxml2:2
	>=gnome-base/gconf-2.6.0:2

	>=net-libs/opal-3.10.9:0=[sip,sound,video,debug=,h323?,xml]
	<net-libs/opal-3.12
	>=net-libs/ptlib-2.10.9:0=[ldap?,stun,v4l?,video,wav,debug=,dtmf,pulseaudio?,xml]
	<net-libs/ptlib-2.12

	>=x11-libs/gtk+-2.20.0:2
	x11-themes/adwaita-icon-theme
	dbus? ( >=sys-apps/dbus-0.36
		>=dev-libs/dbus-glib-0.36 )
	eds? ( >=gnome-extra/evolution-data-server-1.2:= )
	ldap? ( dev-libs/cyrus-sasl:2
		net-nds/openldap )
	libnotify? ( x11-libs/libnotify )
	shm? ( x11-libs/libXext )
	xv? ( x11-libs/libXv )
	zeroconf? ( >=net-dns/avahi-0.6[dbus] )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	sys-devel/gettext
	doc? (
		app-text/rarian
		app-text/gnome-doc-utils
		app-doc/doxygen )
	v4l? ( sys-kernel/linux-headers )
"

# NOTES:
# ptlib/opal needed features are not checked by ekiga, upstream bug 577249
# +doc is not installing dev doc (doxygen)
# UPSTREAM:
# contact ekiga team to be sure intltool and gettext are not nls deps

PATCHES=(
	# https://bugs.gentoo.org/show_bug.cgi?id=499208
	"${FILESDIR}"/${P}-crash-clear.patch
)

src_prepare() {
	# remove call to gconftool-2 --shutdown, upstream bug 555976
	# gnome-2 eclass is reloading schemas with SIGHUP
	sed -i -e '/gconftool-2 --shutdown/d' Makefile.in || die "sed failed"

	# V4L support is auto-enabled, want it to be a user choice
	# do not contact upstream because that's a hack
	# TODO: check if upstream has removed this hack
	if ! use v4l; then
		sed -i -e "s/V4L=\"enabled\"/V4L=\"disabled\"/" configure || die "sed failed"
	fi

	gnome2_src_prepare
}

src_configure() {
	# dbus-service: always enable if dbus is enabled, no reason to disable it
	# Upstream doesn't support experimental stuff:
	# https://bugzilla.gnome.org/show_bug.cgi?id=689301
	# Hence, we disable gstreamer, kde, kab (kontact) 
	gnome2_src_configure \
		--disable-gstreamer \
		--disable-kde \
		--enable-libtool-lock \
		--disable-kab \
		--disable-xcap \
		--enable-gconf \
		--enable-schemas-install \
		--enable-nls \
		--disable-static-libs \
		$(use_enable dbus) \
		$(use_enable dbus dbus_service) \
		$(use_enable debug gtk-debug) \
		$(use_enable debug opal-debug) \
		$(use_enable doc gdu) \
		$(use_enable eds) \
		$(use_enable h323) \
		$(use_enable ldap) \
		$(use_enable libnotify notify) \
		$(use_enable cpu_flags_x86_mmx mmx) \
		$(use_enable shm) \
		$(use_enable xv) \
		$(use_enable zeroconf avahi)
}

src_install() {
	gnome2_src_install

	if use doc && use dbus; then
		insinto "/usr/share/doc/${PF}/"
		doins doc/using_dbus.html
	fi
}
