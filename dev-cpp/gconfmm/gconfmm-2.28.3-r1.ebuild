# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
GNOME_TARBALL_SUFFIX="bz2"

inherit flag-o-matic gnome2

DESCRIPTION="C++ bindings for GConf"
HOMEPAGE="https://www.gtkmm.org"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86"
IUSE="doc"

RDEPEND="
	>=gnome-base/gconf-2.4:2
	>=dev-cpp/glibmm-2.12:2[doc?]
	>=dev-cpp/gtkmm-2.4:2.4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	append-cxxflags -std=c++11 #568580
	gnome2_src_configure \
		$(use_enable doc documentation)
}

src_install() {
	gnome2_src_install

	if use doc ; then
		dohtml -r docs/reference/html/*
	fi
}
