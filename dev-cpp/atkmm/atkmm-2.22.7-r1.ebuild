# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"
#GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal

DESCRIPTION="C++ interface for the ATK library"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc"

COMMON_DEPEND="
	>=dev-cpp/glibmm-2.36.0:2[doc?,${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.8.0[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.3.2:2[${MULTILIB_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	!<dev-cpp/gtkmm-2.22.0
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtkmmlibs-20140508
		!app-emulation/emul-linux-x86-gtkmmlibs[-abi_x86_32(-)] )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

multilib_src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(multilib_native_use_enable doc documentation)
}

multilib_src_install() {
	gnome2_src_install
}
