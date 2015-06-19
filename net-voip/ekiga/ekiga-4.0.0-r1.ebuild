# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-voip/ekiga/ekiga-4.0.0-r1.ebuild,v 1.12 2015/01/28 23:03:46 mgorny Exp $

EAPI=5

KDE_REQUIRED="optional"
CMAKE_REQUIRED="never"
GCONF_DEBUG="no" # debug managed by the ebuild

inherit eutils kde4-base gnome2
# gnome2 at the end to make it default

DESCRIPTION="H.323 and SIP VoIP softphone"
HOMEPAGE="http://www.ekiga.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="avahi dbus debug doc eds gconf gnome gstreamer h323 kde kontact ldap
libnotify cpu_flags_x86_mmx nls pulseaudio +shm static v4l xcap xv"

RDEPEND=">=dev-libs/glib-2.24.0:2
	>=dev-libs/boost-1.49
	dev-libs/libxml2:2
	>=net-libs/opal-3.10.9[sip,sound,video,debug=,h323?,xml]
	>=net-libs/ptlib-2.10.9[ldap?,stun,v4l?,video,wav,debug=,dtmf,pulseaudio?,xml]
	>=x11-libs/gtk+-2.20.0:2
	>=x11-themes/gnome-icon-theme-3.0.0
	avahi? ( >=net-dns/avahi-0.6[dbus] )
	dbus? ( >=sys-apps/dbus-0.36
		>=dev-libs/dbus-glib-0.36 )
	eds? ( >=gnome-extra/evolution-data-server-1.2 )
	gconf? ( >=gnome-base/gconf-2.6.0:2 )
	gnome? ( || ( >=x11-libs/gtk+-2.20.0:2
		( >=gnome-base/libgnome-2.14.0
		>=gnome-base/libgnomeui-2.14.0 ) ) )
	gstreamer? ( >=media-libs/gst-plugins-base-0.10.21.3:0.10 )
	kde? ( kontact? ( $(add_kdebase_dep kdepimlibs) ) )
	ldap? ( dev-libs/cyrus-sasl:2
		net-nds/openldap )
	libnotify? ( x11-libs/libnotify )
	shm? ( x11-libs/libXext )
	xcap? ( net-libs/libsoup:2.4 )
	xv? ( x11-libs/libXv )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	sys-devel/gettext
	doc? ( app-text/scrollkeeper
		app-text/gnome-doc-utils
		app-doc/doxygen )
	v4l? ( sys-kernel/linux-headers )"

DOCS="AUTHORS ChangeLog FAQ MAINTAINERS NEWS README TODO"

# NOTES:
# having >=gtk+-2.14 is actually removing need of +gnome but it's clearer to
# 	represent it with || in gnome dep
# TODO: gnome2 eclass add --[dis|en]able-gtk-doc wich throws a QA warning
#	a patch has been submitted, see bug 262491
# ptlib/opal needed features are not checked by ekiga, upstream bug 577249
# +doc is not installing dev doc (doxygen)

# UPSTREAM:
# contact ekiga team to be sure intltool and gettext are not nls deps

pkg_setup() {
	forceconf=""

	if use kde; then
		kde4-base_pkg_setup
	fi

	if use kontact && ! use kde; then
		ewarn "To enable kontact USE flag, you need kde USE flag to be enabled."
		ewarn "If you need kontact support, please, re-emerge with kde enabled."
		forceconf="${forceconf} --disable-kab"
	fi

	# dbus-service: always enable if dbus is enabled, no reason to disable it
	# schemas-install: install gconf schemas
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--disable-maintainer-mode
		--enable-libtool-lock
		$(use_enable avahi)
		$(use_enable dbus)
		$(use_enable dbus dbus_service)
		$(use_enable debug gtk-debug)
		$(use_enable debug opal-debug)
		$(use_enable doc gdu)
		$(use_enable eds)
		$(use_enable gconf)
		$(use_enable gconf schemas-install)
		$(use_enable gstreamer)
		$(use_enable h323)
		$(use_enable kde)
		$(use_enable kontact kab)
		$(use_enable ldap)
		$(use_enable libnotify notify)
		$(use_enable cpu_flags_x86_mmx mmx)
		$(use_enable nls)
		$(use_enable shm)
		$(use_enable static static-libs)
		$(use_enable xcap)
		$(use_enable xv)
		${forceconf}"
}

src_prepare() {

	gnome2_src_prepare

	# remove call to gconftool-2 --shutdown, upstream bug 555976
	# gnome-2 eclass is reloading schemas with SIGHUP
	sed -i -e '/gconftool-2 --shutdown/d' Makefile.in || die "sed failed"

	# V4L support is auto-enabled, want it to be a user choice
	# do not contact upstream because that's a hack
	# TODO: check if upstream has removed this hack
	if ! use v4l; then
		sed -i -e "s/V4L=\"enabled\"/V4L=\"disabled\"/" configure \
			|| die "sed failed"
	fi

	# compatibility with kdeprefix, fix bug 283033
	if use kde; then
		sed -i -e "s:\tKDE_CFLAGS=\(.*\):\tKDE_CFLAGS=\"\1 -I${KDEDIR}/include\":" \
			configure || die "sed failed"
		sed -i -e "s:\(KDE_LIBS=.*\)\(-lkdeui\):\1-L${KDEDIR}/$(get_libdir) \2:" \
			configure || die "sed failed"
	fi

	# Remove silly -D*_DISABLE_DEPRECATED CFLAGS
	sed -e 's/-D[^\s\t]\+_DISABLE_DEPRECATED//g' -i configure || die
}

src_test() {
	# must be explicit because kde4-base in exporting a src_test function
	emake -j1 check || die "emake check failed"
}

src_install() {
	gnome2_src_install

	if use doc && use dbus; then
		insinto "/usr/share/doc/${PF}/"
		doins doc/using_dbus.html || die "doins failed"
	fi
}

pkg_postinst() {
	gnome2_pkg_postinst

	if use kde; then
		kde4-base_pkg_postinst
	fi

	if ! use gnome; then
		ewarn "USE=-gnome is experimental, weirdness with UI and config keys can appear."
	fi

	if use gstreamer || use kde || use xcap || use kontact; then
		ewarn "You have enabled gstreamer, kde, xcap or kontact USE flags."
		ewarn "Those USE flags are considered experimental features."
	fi
}

pkg_postrm() {
	gnome2_pkg_postrm

	if use kde; then
		kde4-base_pkg_postrm
	fi
}
