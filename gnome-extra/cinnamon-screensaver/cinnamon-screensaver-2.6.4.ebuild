# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 multilib python-single-r1

DESCRIPTION="Screensaver for Cinnamon"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-screensaver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc pam systemd"
KEYWORDS="amd64 x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.37.3:2[dbus]
	>=x11-libs/gtk+-3.1.4:3[introspection]
	>=gnome-extra/cinnamon-desktop-2.6.3:0=[systemd=]
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=gnome-base/libgnomekbd-3.6
	>=dev-libs/dbus-glib-0.78

	net-libs/webkit-gtk:3[introspection]

	sys-apps/dbus
	x11-libs/libxklavier
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	x11-themes/gnome-icon-theme-symbolic

	${PYTHON_DEPS}

	pam? ( virtual/pam )
	systemd? ( >=sys-apps/systemd-31:0= )
"
# our cinnamon-1.8 ebuilds installed a cinnamon-screensaver.desktop hack
RDEPEND="
	!~gnome-extra/cinnamon-1.8.8.1
	!systemd? ( sys-auth/consolekit )

	dev-python/pygobject:3[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/randrproto
	x11-proto/scrnsaverproto
	x11-proto/xf86miscproto
	doc? (
		app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.4 )
"

pkg_setup() {
	python_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.6.3-automagic-logind.patch

	# Fix xscreensaver paths for gentoo
	sed -e "s#/usr/lib/xscreensaver/#${EPREFIX}/usr$(get_libdir)/misc/xscreensaver/#" \
		-i data/screensavers/xscreensaver@cinnamon.org/main || die

	python_fix_shebang data/screensavers

	epatch_user
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	gnome2_src_configure \
		$(use_enable doc docbook-docs) \
		$(use_enable pam locking) \
		$(use_enable systemd logind) \
		--with-mit-ext \
		--with-pam-prefix=/etc \
		--with-xf86gamma-ext \
		--with-kbd-layout-indicator
	# Do not use --without-console-kit, it would provide no benefit: there is
	# no build-time or run-time check for consolekit, $PN merely listens to
	# consolekit's messages over dbus.
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version x11-misc/xscreensaver; then
		elog "${PN} can use screensavers from x11-misc/xscreensaver"
	fi
}
