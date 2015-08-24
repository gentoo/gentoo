# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 multilib-minimal virtualx

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="https://live.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="~alpha ~amd64 arm hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.11.2[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.11.90[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.5[${MULTILIB_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/at-spi-1.32.0-r1
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508-r3
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure --enable-p2p
}

multilib_src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}

multilib_src_compile() { gnome2_src_compile; }
multilib_src_install() { gnome2_src_install; }
