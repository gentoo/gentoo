# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit eutils gnome2 multilib-minimal

DESCRIPTION="GTK+2 standard engines and themes"
HOMEPAGE="http://www.gtk.org/"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ~ia64 ~mips ~ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="accessibility lua"

RDEPEND="
	>=x11-libs/gtk+-2.24.23:2[${MULTILIB_USEDEP}]
	lua? ( dev-lang/lua:0[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.31
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

src_prepare() {
	# Patch from 2.21.x, fixes building with glib-2.32, bug #410455
	epatch "${FILESDIR}/${P}-glib.h.patch"

	# Fix java apps look, bug #523074
	epatch "${FILESDIR}/${P}-java-look.patch"

	# Apply Fedora fixes/improvements
	epatch "${FILESDIR}"/${P}-auto-mnemonics.patch
	epatch "${FILESDIR}"/${P}-change-bullet.patch
	epatch "${FILESDIR}"/${P}-tooltips.patch
	epatch "${FILESDIR}"/${P}-window-dragging.patch

	gnome2_src_prepare
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--enable-animation \
		$(use_enable lua) \
		$(use_with lua system-lua) \
		$(use_enable accessibility hc)
}

multilib_src_install() {
	gnome2_src_install
}

multilib_src_install_all() {
	einstalldocs
}
