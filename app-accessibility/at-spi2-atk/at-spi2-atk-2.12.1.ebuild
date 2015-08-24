# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 virtualx

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="https://live.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.11.2
	>=dev-libs/atk-2.11.90
	>=dev-libs/glib-2.32:2
	>=sys-apps/dbus-1.5
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/at-spi-1.32.0-r1
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure --enable-p2p
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}
