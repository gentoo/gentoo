# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"
WANT_AUTOMAKE="1.12"
VALA_MIN_API_VERSION="0.14"
VALA_USE_DEPEND="vapigen"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 vala

DESCRIPTION="Set of GObject and Gtk objects for connecting to Spice servers and a client GUI"
HOMEPAGE="http://spice-space.org http://gitorious.org/spice-gtk"

LICENSE="LGPL-2.1"
SLOT="0"
SRC_URI="http://spice-space.org/download/gtk/${P}.tar.bz2"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="dbus doc gstreamer gtk3 +introspection policykit pulseaudio
python sasl smartcard static-libs usbredir vala"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	?? ( pulseaudio gstreamer )"

# TODO:
# * check if sys-freebsd/freebsd-lib (from virtual/acl) provides acl/libacl.h
# * use external pnp.ids as soon as that means not pulling in gnome-desktop
RDEPEND="${PYTHON_DEPS}
	pulseaudio? ( media-sound/pulseaudio[glib] )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10 )
	>=x11-libs/pixman-0.17.7
	>=media-libs/celt-0.5.1.1:0.5.1
	dev-libs/openssl
	gtk3? ( x11-libs/gtk+:3[introspection?] )
	x11-libs/gtk+:2[introspection?]
	>=dev-libs/glib-2.26:2
	>=x11-libs/cairo-1.2
	virtual/jpeg
	sys-libs/zlib
	dbus? ( dev-libs/dbus-glib )
	introspection? ( dev-libs/gobject-introspection )
	python? ( dev-python/pygtk:2 )
	sasl? ( dev-libs/cyrus-sasl )
	smartcard? ( app-emulation/libcacard )
	usbredir? (
		sys-apps/hwids
		>=sys-apps/usbredir-0.4.2
		virtual/libusb:1
		virtual/libgudev:=
		policykit? (
			sys-apps/acl
			>=sys-auth/polkit-0.110-r1
			!~sys-auth/polkit-0.111 )
		)"
DEPEND="${RDEPEND}
	dev-lang/python
	dev-python/pyparsing
	dev-perl/Text-CSV
	>=dev-util/intltool-0.40.0
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	vala? ( $(vala_depend) )"

# Hard-deps while building from git:
# dev-lang/vala:0.14
# dev-lang/perl

GTK2_BUILDDIR="${WORKDIR}/${P}_gtk2"
GTK3_BUILDDIR="${WORKDIR}/${P}_gtk3"

src_prepare() {

	epatch "${FILESDIR}"/spice-gtk-0.21-fix-g-clear-pointer-on-old-glib.patch

	epatch_user

	use vala && vala_src_prepare
	mkdir ${GTK2_BUILDDIR} ${GTK3_BUILDDIR} || die
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
		$(use_enable static-libs static) \
		$(use_enable introspection) \
		--with-audio=${audio} \
		$(use_with python) \
		$(use_with sasl) \
		$(use_enable smartcard) \
		$(use_enable usbredir) \
		$(use_with usbredir usb-ids-path /usr/share/misc/usb.ids) \
		$(use_with usbredir usb-acl-helper-dir /usr/libexec) \
		$(use_enable policykit polkit) \
		$(use_enable vala) \
		$(use_enable dbus) \
		$(use_enable doc gtk-doc) \
		--disable-werror \
		--enable-pie"

	cd ${GTK2_BUILDDIR}
	echo "Running configure in ${GTK2_BUILDDIR}"
	ECONF_SOURCE="${S}" econf --disable-maintainer-mode \
		--with-gtk=2.0 \
		${myconf}

	if use gtk3; then
		cd ${GTK3_BUILDDIR}
		echo "Running configure in ${GTK3_BUILDDIR}"
		ECONF_SOURCE="${S}" econf --disable-maintainer-mode \
			--with-gtk=3.0 \
			${myconf}
	fi
}

src_compile() {
	cd ${GTK2_BUILDDIR}
	einfo "Running make in ${GTK2_BUILDDIR}"
	default

	if use gtk3; then
		cd ${GTK3_BUILDDIR}
		einfo "Running make in ${GTK3_BUILDDIR}"
		default
	fi
}

src_test() {
	cd ${GTK2_BUILDDIR}
	einfo "Running make check in ${GTK2_BUILDDIR}"
	default

	if use gtk3; then
		cd ${GTK3_BUILDDIR}
		einfo "Running make check in ${GTK3_BUILDDIR}"
		default
	fi
}

src_install() {
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO

	cd ${GTK2_BUILDDIR}
	einfo "Running make check in ${GTK2_BUILDDIR}"
	default

	if use gtk3; then
		cd ${GTK3_BUILDDIR}
		einfo "Running make install in ${GTK3_BUILDDIR}"
		default
	fi

	# Remove .la files if they're not needed
	use static-libs || prune_libtool_files

	use python && rm -rf "${ED}"/usr/lib*/python*/site-packages/*.la

	make_desktop_entry spicy Spicy "utilities-terminal" "Network;RemoteAccess;"
}
