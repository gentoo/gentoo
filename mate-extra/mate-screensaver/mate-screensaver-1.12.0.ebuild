# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate multilib readme.gentoo-r1

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Replaces xscreensaver, integrating with the MATE desktop"
LICENSE="GPL-2"
SLOT="0"

IUSE="X debug consolekit gtk3 kernel_linux libnotify opengl pam systemd"

DOC_CONTENTS="
	Information for converting screensavers is located in
	/usr/share/doc/${PF}/xss-conversion.txt*
"

RDEPEND="
	>=dev-libs/dbus-glib-0.71:0
	>=dev-libs/glib-2.36:2
	gnome-base/dconf:0
	>=mate-base/libmatekbd-1.7.1[gtk3(-)=]
	>=mate-base/mate-desktop-1.9.4[gtk3(-)=]
	>=mate-base/mate-menus-1.6
	>=mate-base/mate-session-manager-1.6[gtk3(-)=]
	>=sys-apps/dbus-0.30:0
	>=x11-libs/gdk-pixbuf-2.14:2
	>=x11-libs/libX11-1:0
	x11-libs/cairo:0
	x11-libs/libXext:0
	x11-libs/libXrandr:0
	x11-libs/libXScrnSaver:0
	x11-libs/libXxf86misc:0
	x11-libs/libXxf86vm:0
	x11-libs/libxklavier:0
	x11-libs/pango:0
	virtual/libintl:0
	consolekit? ( sys-auth/consolekit:0 )
	!gtk3? ( >=x11-libs/gtk+-2.24:2 )
	gtk3? ( >=x11-libs/gtk+-3.0:3 )
	libnotify? ( >=x11-libs/libnotify-0.7:0 )
	opengl? ( virtual/opengl:0 )
	pam? ( gnome-base/gnome-keyring:0 virtual/pam:0 )
	!pam? ( kernel_linux? ( sys-apps/shadow:0 ) )
	systemd? ( sys-apps/systemd:0= )
	!!<gnome-extra/gnome-screensaver-3:0"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	x11-proto/randrproto:0
	x11-proto/scrnsaverproto:0
	x11-proto/xextproto:0
	x11-proto/xf86miscproto:0
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		--enable-locking \
		--with-kbd-layout-indicator \
		--with-xf86gamma-ext \
		--with-xscreensaverdir=/usr/share/xscreensaver/config \
		--with-xscreensaverhackdir=/usr/$(get_libdir)/misc/xscreensaver \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_with X x) \
		$(use_with consolekit console-kit) \
		$(use_with libnotify) \
		$(use_with opengl libgl) \
		$(use_with systemd) \
		$(use_enable debug) \
		$(use_enable pam)
}

src_install() {
	mate_src_install

	# Install the conversion script in the documentation.
	dodoc "${S}"/data/migrate-xscreensaver-config.sh
	dodoc "${S}"/data/xscreensaver-config.xsl
	dodoc "${FILESDIR}"/xss-conversion.txt

	# Non PAM users will need this suid to read the password hashes.
	# OpenPAM users will probably need this too when
	# http://bugzilla.gnome.org/show_bug.cgi?id=370847
	# is fixed.
	if ! use pam ; then
		fperms u+s /usr/libexec/mate-screensaver-dialog
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	mate_pkg_postinst

	if has_version "<x11-base/xorg-server-1.5.3-r4" ; then
		ewarn "You have a too old xorg-server installation. This will cause"
		ewarn "mate-screensaver to eat up your CPU. Please consider upgrading."
		echo
	fi

	if has_version "<x11-misc/xscreensaver-4.22-r2" ; then
		ewarn "You have xscreensaver installed, you probably want to disable it."
		ewarn "To prevent a duplicate screensaver entry in the menu, you need to"
		ewarn "build xscreensaver with -gnome in the USE flags."
		ewarn "echo \"x11-misc/xscreensaver -gnome\" >> /etc/portage/package.use"
		echo
	fi

	readme.gentoo_print_elog
}
