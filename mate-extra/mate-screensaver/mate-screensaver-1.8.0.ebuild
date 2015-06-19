# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mate-extra/mate-screensaver/mate-screensaver-1.8.0.ebuild,v 1.6 2014/07/07 23:18:35 tomwij Exp $

EAPI="5"

GCONF_DEBUG="yes"

inherit gnome2 multilib versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="Replaces xscreensaver, integrating with the MATE desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="X consolekit kernel_linux libnotify opengl pam systemd"

RDEPEND="
	>=dev-libs/dbus-glib-0.71:0
	>=dev-libs/glib-2.26:2
	gnome-base/dconf:0
	>=mate-base/libmatekbd-1.8:0
	>=mate-base/mate-desktop-1.8:0
	>=mate-base/mate-menus-1.6:0
	>=sys-apps/dbus-0.30:0
	>=x11-libs/gdk-pixbuf-2.14:2
	>=x11-libs/gtk+-2.14:2
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
	libnotify? ( >=x11-libs/libnotify-0.7:0 )
	opengl? ( virtual/opengl:0 )
	pam? ( gnome-base/gnome-keyring:0 virtual/pam:0 )
	!pam? ( kernel_linux? ( sys-apps/shadow:0 ) )
	!!<gnome-extra/gnome-screensaver-3:0"

# FIXME: Why is systemd and consolekit only a DEPEND? ConsoleKit can't be used build-time only.
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35:*
	>=mate-base/mate-common-1.6:0
	sys-devel/gettext:*
	x11-proto/randrproto:0
	x11-proto/scrnsaverproto:0
	x11-proto/xextproto:0
	x11-proto/xf86miscproto:0
	virtual/pkgconfig:*
	consolekit? ( sys-auth/consolekit:0 )
	systemd? ( sys-apps/systemd:0= )"

src_configure() {
	gnome2_src_configure \
		$(use_with consolekit console-kit) \
		$(use_enable debug) \
		$(use_with libnotify) \
		$(use_with opengl libgl) \
		$(use_enable pam) \
		$(use_with systemd) \
		$(use_with X x) \
		--enable-locking \
		--with-kbd-layout-indicator \
		--with-xf86gamma-ext \
		--with-xscreensaverdir=/usr/share/xscreensaver/config \
		--with-xscreensaverhackdir=/usr/$(get_libdir)/misc/xscreensaver
}

DOCS="AUTHORS ChangeLog NEWS README"

src_install() {
	gnome2_src_install

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
}

pkg_postinst() {
	gnome2_pkg_postinst

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

	elog "Information for converting screensavers is located in "
	elog "/usr/share/doc/${PF}/xss-conversion.txt.${PORTAGE_COMPRESS}"
}
