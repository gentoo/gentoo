# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools gnome2 multilib python-single-r1

DESCRIPTION="Screensaver for Cinnamon"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-screensaver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="debug doc pam systemd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="amd64 x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.37.3:2[dbus]
	>=x11-libs/gtk+-3.1.4:3[introspection]
	>=gnome-extra/cinnamon-desktop-2.6.3:0=[systemd=]
	>=gnome-base/gsettings-desktop-schemas-0.1.7
	>=gnome-base/libgnomekbd-3.6
	>=dev-libs/dbus-glib-0.78

	net-libs/webkit-gtk:4[introspection]

	sys-apps/dbus
	x11-libs/libxklavier
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXScrnSaver
	x11-libs/libXxf86misc
	x11-libs/libXxf86vm
	x11-themes/adwaita-icon-theme

	${PYTHON_DEPS}

	pam? ( virtual/pam )
	systemd? ( >=sys-apps/systemd-31:0= )
"
# our cinnamon-1.8 ebuilds installed a cinnamon-screensaver.desktop hack
RDEPEND="${COMMON_DEPEND}
	!~gnome-extra/cinnamon-1.8.8.1
	!systemd? ( sys-auth/consolekit )
	dev-python/pygobject:3[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	x11-base/xorg-proto
	doc? (
		app-text/xmlto
		app-text/docbook-xml-dtd:4.1.2
		app-text/docbook-xml-dtd:4.4 )
"

pkg_setup() {
	python_setup
}

src_prepare() {
	eapply "${FILESDIR}"/${PN}-3.0.1-automagic-logind.patch
	eapply "${FILESDIR}"/${PN}-2.8.0-webkit4.patch #566572

	# Fix xscreensaver paths for gentoo
	sed -e "s#/usr/lib/xscreensaver/#${EPREFIX}/usr/$(get_libdir)/misc/xscreensaver/#" \
		-i data/screensavers/xscreensaver@cinnamon.org/main || die

	python_fix_shebang data/screensavers

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(usex debug --enable-debug ' ') \
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
