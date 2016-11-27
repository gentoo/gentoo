# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

SRC_URI="https://github.com/linuxmint/xapps/archive/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

DESCRIPTION="Cross-desktop libraries and common resources"
HOMEPAGE="https://github.com/linuxmint/xapps/"

LICENSE="LGPL-3"
SLOT="0"

RDEPEND="
	>=x11-libs/gdk-pixbuf-2.22.0:2[introspection]
	>=x11-libs/gtk+-3.3.16:3[introspection]
	>=dev-libs/glib-2.37.3:2
	x11-libs/cairo
	gnome-base/libgnomekbd
	gnome-base/gnome-common
"
DEPEND="${RDEPEND}"

src_prepare(){
	eautoreconf
	default
}

src_install(){
	default
	rm -rf "${D}/usr/bin/" || die
}
