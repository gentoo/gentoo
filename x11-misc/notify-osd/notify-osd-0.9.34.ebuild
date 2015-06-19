# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/notify-osd/notify-osd-0.9.34.ebuild,v 1.5 2012/07/30 21:01:34 ssuominen Exp $

EAPI=4
inherit autotools gnome2-utils multilib savedconfig

DESCRIPTION="Canonical's on-screen-display notification agent"
HOMEPAGE="http://launchpad.net/notify-osd"
SRC_URI="http://launchpad.net/${PN}/precise/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.98
	>=dev-libs/glib-2.16
	>=x11-libs/gtk+-3.2:3
	>=x11-libs/libnotify-0.7
	>=x11-libs/libwnck-3
	x11-libs/libX11
	x11-libs/pixman
	!x11-misc/notification-daemon
	!x11-misc/qtnotifydaemon"
RDEPEND="${COMMON_DEPEND}
	!minimal? ( x11-themes/notify-osd-icons )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	gnome-base/gnome-common
	x11-proto/xproto"

RESTRICT="test" # virtualx.eclass: 1 of 1: FAIL: test-modules

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	sed -i -e 's:noinst_PROG:check_PROG:' tests/Makefile.am || die
	restore_config src/{bubble,defaults,dnd}.c #428134
	eautoreconf
}

src_configure() {
	econf --libexecdir=/usr/$(get_libdir)/${PN}
}

src_install() {
	default
	save_config src/{bubble,defaults,dnd}.c
	rm -f "${ED}"/usr/share/${PN}/icons/*/*/*/README
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}
pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
}
