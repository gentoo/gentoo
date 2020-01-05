# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit autotools gnome2 multilib python-single-r1

DESCRIPTION="Screensaver for Cinnamon"
HOMEPAGE="http://developer.linuxmint.com/projects/cinnamon-projects.html"
SRC_URI="https://github.com/linuxmint/cinnamon-screensaver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="debug doc pam systemd xinerama"
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

	!systemd? ( sys-auth/elogind )

	${PYTHON_DEPS}

	pam? ( sys-libs/pam )
	systemd? ( >=sys-apps/systemd-31:0= )
	xinerama? ( x11-libs/libXinerama )
"
# our cinnamon-1.8 ebuilds installed a cinnamon-screensaver.desktop hack
RDEPEND="${COMMON_DEPEND}
	!~gnome-extra/cinnamon-1.8.8.1
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/xapp[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
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
	python_fix_shebang screensavers
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(usex debug --enable-debug ' ') \
		$(use_enable xinerama)
}

pkg_postinst() {
	gnome2_pkg_postinst

	if ! has_version x11-misc/xscreensaver; then
		elog "${PN} can use screensavers from x11-misc/xscreensaver"
	fi

}
