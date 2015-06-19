# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/gconfmm/gconfmm-2.28.3.ebuild,v 1.8 2012/05/04 03:44:57 jdhore Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="C++ bindings for GConf"
HOMEPAGE="http://www.gtkmm.org"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="doc"

RDEPEND=">=gnome-base/gconf-2.4:2
	>=dev-cpp/glibmm-2.12:2[doc?]
	>=dev-cpp/gtkmm-2.4:2.4"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	DOCS="AUTHORS COPYING* ChangeLog NEWS README INSTALL"
	G2CONF="${G2CONF}
		$(use_enable doc documentation)"
}

src_install() {
	gnome2_src_install

	if use doc ; then
		dohtml -r docs/reference/html/*
	fi
}
