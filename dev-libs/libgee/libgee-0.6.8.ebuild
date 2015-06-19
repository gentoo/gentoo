# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgee/libgee-0.6.8.ebuild,v 1.11 2014/06/20 14:44:56 ago Exp $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GObject-based interfaces and classes for commonly used data structures"
HOMEPAGE="https://live.gnome.org/Libgee"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 ~sh sparc x86 ~x86-linux"
IUSE="+introspection"

RDEPEND=">=dev-libs/glib-2.12:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.6:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	DOCS="AUTHORS ChangeLog* MAINTAINERS NEWS README"
	gnome2_src_configure $(use_enable introspection)
}
