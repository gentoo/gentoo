# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"
WANT_AUTOMAKE="1.12"
VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"

inherit autotools eutils vala git-r3 readme.gentoo-r1

DESCRIPTION="Set of GObject and Gtk objects for connecting to Spice servers and a client GUI"
HOMEPAGE="http://spice-space.org https://cgit.freedesktop.org/spice/spice-gtk/"

LICENSE="LGPL-2.1"
SLOT="0"
EGIT_REPO_URI="git://anongit.freedesktop.org/spice/spice-gtk.git"
KEYWORDS=""
IUSE="dbus gstaudio gstvideo gtk3 +introspection lz4 mjpeg policykit pulseaudio sasl smartcard static-libs usbredir vala webdav libressl"

REQUIRED_USE="?? ( pulseaudio gstaudio )"
# TODO:
# * check if sys-freebsd/freebsd-lib (from virtual/acl) provides acl/libacl.h
# * use external pnp.ids as soon as that means not pulling in gnome-desktop
RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	pulseaudio? ( media-sound/pulseaudio[glib] )
	gstvideo? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0
		)
	gstaudio? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
		media-libs/gst-plugins-good:1.0
		)
	>=x11-libs/pixman-0.17.7
	>=media-libs/celt-0.5.1.1:0.5.1
	media-libs/opus
	gtk3? ( x11-libs/gtk+:3[introspection?] )
	>=dev-libs/glib-2.36:2
	>=x11-libs/cairo-1.2
	virtual/jpeg:0=
	sys-libs/zlib
	introspection? ( dev-libs/gobject-introspection )
	lz4? ( app-arch/lz4 )
	sasl? ( dev-libs/cyrus-sasl )
	smartcard? ( app-emulation/qemu[smartcard] )
	usbredir? (
		sys-apps/hwids
		>=sys-apps/usbredir-0.4.2
		virtual/libusb:1
		virtual/libgudev:=
		policykit? (
			sys-apps/acl
			>=sys-auth/polkit-0.110-r1
			!~sys-auth/polkit-0.111 )
		)
	webdav? (
		net-libs/phodav:2.0
		>=dev-libs/glib-2.43.90:2
		>=net-libs/libsoup-2.49.91 )
"
DEPEND="${RDEPEND}
	=app-emulation/spice-protocol-9999
	dev-perl/Text-CSV
	>=dev-util/gtk-doc-am-1.14
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

# Hard-deps while building from git:
# dev-lang/vala:0.14
# dev-lang/perl

# Prevent sandbox violations, bug #581836
# https://bugzilla.gnome.org/show_bug.cgi?id=581836
addpredict /dev

src_prepare() {
	epatch_user

	eautoreconf

	use vala && vala_src_prepare
}

src_configure() {
	local myconf

	if use vala ; then
		# force vala regen for MinGW, etc
		rm -fv gtk/controller/controller.{c,vala.stamp} gtk/controller/menu.c
	fi

	myconf="
		--disable-maintainer-mode \
		$(use_enable static-libs static) \
		$(use_enable introspection) \
		$(use_with sasl) \
		$(use_enable smartcard) \
		$(use_enable usbredir) \
		$(use_with usbredir usb-ids-path /usr/share/misc/usb.ids) \
		$(use_with usbredir usb-acl-helper-dir /usr/libexec) \
		$(use_with gtk3 gtk 3.0) \
		$(use_enable policykit polkit) \
		$(use_enable pulseaudio pulse) \
		$(use_enable gstaudio) \
		$(use_enable gstvideo) \
		$(use_enable mjpeg builtin-mjpeg) \
		$(use_enable vala) \
		$(use_enable webdav) \
		$(use_enable dbus) \
		--disable-gtk-doc \
		--disable-werror \
		--enable-pie"

	econf ${myconf}
}

src_install() {
	default

	dodoc AUTHORS NEWS README TODO

	# Remove .la files if they're not needed
	use static-libs || prune_libtool_files

	make_desktop_entry spicy Spicy "utilities-terminal" "Network;RemoteAccess;"
	readme.gentoo_create_doc
}
