# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit flag-o-matic gnome2

DESCRIPTION="C++ bindings for libgnome"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1"
SLOT="2.6"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	>=dev-cpp/gtkmm-2.8:2.4
	>=gnome-base/libgnome-2.6
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	append-cxxflags -std=c++11
	gnome2_src_prepare
}
