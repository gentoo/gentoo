# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/pangomm/pangomm-2.34.0-r1.ebuild,v 1.7 2015/06/07 10:21:52 maekke Exp $

EAPI=5
GCONF_DEBUG="no"
#GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal

DESCRIPTION="C++ interface for pango"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="1.4"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 ~sh ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc"

COMMON_DEPEND="
	>=x11-libs/pango-1.32.5[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.36.0:2[${MULTILIB_USEDEP}]
	>=dev-cpp/cairomm-1.10.0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.3.2:2[${MULTILIB_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? (
		media-gfx/graphviz
		dev-libs/libxslt
		app-doc/doxygen )
"
RDEPEND="${COMMON_DEPEND}
	!<dev-cpp/gtkmm-2.13:2.4
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtkmmlibs-20140508
		!app-emulation/emul-linux-x86-gtkmmlibs[-abi_x86_32(-)] )
"

multilib_src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(multilib_native_use_enable doc documentation)
}

multilib_src_install() {
	gnome2_src_install
}
