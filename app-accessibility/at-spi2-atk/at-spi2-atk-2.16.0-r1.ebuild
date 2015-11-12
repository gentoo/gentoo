# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 multilib-minimal

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="https://live.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ~ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="test"

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.15.5[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.15.4[${MULTILIB_USEDEP}]
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
	test? ( >=dev-libs/libxml2-2.9.1 )
"

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=751137
	epatch "${FILESDIR}"/${PN}-2.16.0-out-of-source.patch
	# Fixed in upstream git
	epatch "${FILESDIR}"/${P}-null-gobject.patch
	# Upstream forgot to put this in tarball :/
	# https://bugzilla.gnome.org/show_bug.cgi?id=751138
	cp -n "${FILESDIR}"/${PN}-2.16.0-atk_suite.h tests/atk_suite.h || die
	mkdir tests/data/ || die
	cp -n "${FILESDIR}"/${PN}-2.16.0-tests-data/*.xml tests/data/ || die

	eautoreconf
	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure --enable-p2p $(use_with test tests)
}

multilib_src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	dbus-run-session -- emake check
}

multilib_src_compile() { gnome2_src_compile; }
multilib_src_install() { gnome2_src_install; }
