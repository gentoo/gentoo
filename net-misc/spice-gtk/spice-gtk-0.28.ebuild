# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/spice-gtk/spice-gtk-0.28.ebuild,v 1.2 2015/06/13 16:04:24 pacho Exp $

EAPI=5
GCONF_DEBUG="no"
WANT_AUTOMAKE="1.12"
VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils multibuild python-single-r1 vala

DESCRIPTION="Set of GObject and Gtk objects for connecting to Spice servers and a client GUI"
HOMEPAGE="http://spice-space.org http://gitorious.org/spice-gtk"

LICENSE="LGPL-2.1"
SLOT="0"
SRC_URI="http://spice-space.org/download/gtk/${P}.tar.bz2"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="dbus gstreamer gtk3 +introspection lz4 policykit pulseaudio python sasl smartcard static-libs usbredir vala webdav"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	?? ( pulseaudio gstreamer )
"

# TODO:
# * check if sys-freebsd/freebsd-lib (from virtual/acl) provides acl/libacl.h
# * use external pnp.ids as soon as that means not pulling in gnome-desktop
RDEPEND="
	${PYTHON_DEPS}
	pulseaudio? ( media-sound/pulseaudio[glib] )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0 )
	>=x11-libs/pixman-0.17.7
	>=media-libs/celt-0.5.1.1:0.5.1
	media-libs/opus
	dev-libs/openssl:=
	gtk3? ( x11-libs/gtk+:3[introspection?] )
	x11-libs/gtk+:2[introspection?]
	>=dev-libs/glib-2.28:2
	>=x11-libs/cairo-1.2
	virtual/jpeg:=
	sys-libs/zlib
	introspection? ( dev-libs/gobject-introspection )
	lz4? ( app-arch/lz4 )
	python? ( dev-python/pygtk:2 )
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
	dev-lang/python
	dev-python/pyparsing
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

src_prepare() {
	epatch_user

	AT_NO_RECURSIVE="yes" eautoreconf

	use vala && vala_src_prepare
}

src_configure() {
	local myconf
	local audio="no"

	use gstreamer && audio="gstreamer"
	use pulseaudio && audio="pulse"

	if use vala ; then
		# force vala regen for MinGW, etc
		rm -fv gtk/controller/controller.{c,vala.stamp} gtk/controller/menu.c
	fi

	myconf="
		--disable-maintainer-mode \
		$(use_enable static-libs static) \
		$(use_enable introspection) \
		--with-audio=${audio} \
		$(use_with sasl) \
		$(use_enable smartcard) \
		$(use_enable usbredir) \
		$(use_with usbredir usb-ids-path /usr/share/misc/usb.ids) \
		$(use_with usbredir usb-acl-helper-dir /usr/libexec) \
		$(use_enable policykit polkit) \
		$(use_enable vala) \
		$(use_enable webdav) \
		$(use_enable dbus) \
		--disable-gtk-doc \
		--disable-werror \
		--enable-pie"

	# Parameter of --with-gtk
	MULTIBUILD_VARIANTS=( 2.0 )
	use gtk3 && MULTIBUILD_VARIANTS+=( 3.0 )

	configure() {
		local myconf=()
		myconf+=( --with-gtk=${MULTIBUILD_VARIANT} )

		if [[ ${MULTIBUILD_ID} =~ "2.0" ]] ; then
			myconf+=( $(use_with python) )
		else
			myconf+=( --without-python )
		fi

		ECONF_SOURCE="${S}" econf $@ ${myconf[@]}
	}
	multibuild_foreach_variant run_in_build_dir configure ${myconf}
}

src_compile() {
	multibuild_foreach_variant run_in_build_dir default
}

src_test() {
	multibuild_foreach_variant run_in_build_dir default
}

src_install() {
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	multibuild_foreach_variant run_in_build_dir default

	# Remove .la files if they're not needed
	use static-libs || prune_libtool_files

	use python && rm -rf "${ED}"/usr/lib*/python*/site-packages/*.la

	make_desktop_entry spicy Spicy "utilities-terminal" "Network;RemoteAccess;"
}
