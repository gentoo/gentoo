# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/atkmm/atkmm-2.22.7.ebuild,v 1.14 2015/03/06 05:04:40 tetromino Exp $

EAPI=5
GCONF_DEBUG="no"
#GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="C++ interface for the ATK library"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE="doc"

RDEPEND="
	>=dev-cpp/glibmm-2.36.0:2[doc?]
	>=dev-libs/atk-1.12
	dev-libs/libsigc++:2
	!<dev-cpp/gtkmm-2.22.0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure $(use_enable doc documentation)
}
