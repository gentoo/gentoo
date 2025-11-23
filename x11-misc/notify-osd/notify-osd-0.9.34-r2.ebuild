# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools gnome2-utils savedconfig

DESCRIPTION="Canonical's on-screen-display notification agent"
HOMEPAGE="https://launchpad.net/notify-osd"
SRC_URI="https://launchpad.net/${PN}/precise/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="
	gnome-base/gsettings-desktop-schemas
	!minimal? ( x11-themes/notify-osd-icons )
"
DEPEND="
	dev-util/glib-utils
	gnome-base/gnome-common
	x11-base/xorg-proto
	virtual/pkgconfig
	>=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.16:2
	>=x11-libs/gtk+-3.2:3
	>=x11-libs/libnotify-0.7
	>=x11-libs/libwnck-3:3
	x11-libs/libX11
	x11-libs/pixman
	!x11-misc/notification-daemon
	!x11-misc/qtnotifydaemon
"

RESTRICT="test" # virtualx.eclass: 1 of 1: FAIL: test-modules

# Patch is upstreamed here: https://answers.launchpad.net/notify-osd/+question/704024
PATCHES=( "${FILESDIR}/${P}-fix-integer-conversion.patch" )

src_prepare() {
	default
	sed -i -e 's:noinst_PROG:check_PROG:' tests/Makefile.am || die
	restore_config src/{bubble,defaults,dnd}.c #428134
	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf --libexecdir="/usr/$(get_libdir)/${PN}"
}

src_install() {
	default
	save_config src/{bubble,defaults,dnd}.c
	rm -f "${ED}"/usr/share/${PN}/icons/*/*/*/README
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
