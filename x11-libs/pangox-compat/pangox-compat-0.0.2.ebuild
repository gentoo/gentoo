# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/pangox-compat/pangox-compat-0.0.2.ebuild,v 1.18 2014/05/14 16:16:36 ago Exp $

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="PangoX compatibility library"
HOMEPAGE="http://www.pango.org/"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=dev-libs/glib-2.31:2
	>=x11-libs/pango-1.32
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	G2CONF="${G2CONF} --disable-static"

	gnome2_src_configure
}
