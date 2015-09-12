# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="GTK update icon cache"
HOMEPAGE="http://www.gtk.org/"
SRC_URI="https://dev.gentoo.org/~eva/distfiles/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+"
SLOT="0"
IUSE=""

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	>=dev-libs/glib-2.43.4:2
	>=x11-libs/gdk-pixbuf-2.30:2
	!<x11-libs/gtk+-2.24.28-r1:2
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	virtual/pkgconfig
"
