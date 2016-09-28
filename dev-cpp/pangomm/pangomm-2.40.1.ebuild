# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2 multilib-minimal

DESCRIPTION="C++ interface for pango"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="1.4"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc"

COMMON_DEPEND="
	>=x11-libs/pango-1.38.0[${MULTILIB_USEDEP}]
	>=dev-cpp/glibmm-2.48.0:2[${MULTILIB_USEDEP}]
	>=dev-cpp/cairomm-1.12.0[${MULTILIB_USEDEP}]
	>=dev-libs/libsigc++-2.3.2:2[${MULTILIB_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
	doc? (
		media-gfx/graphviz
		dev-libs/libxslt
		app-doc/doxygen )
"
RDEPEND="${COMMON_DEPEND}
	!<dev-cpp/gtkmm-2.13:2.4
"

multilib_src_configure() {
	ECONF_SOURCE="${S}" gnome2_src_configure \
		$(multilib_native_use_enable doc documentation)
}

multilib_src_install() {
	gnome2_src_install
}
