# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2

DESCRIPTION="Library for code commong to Gnome games"
HOMEPAGE="https://git.gnome.org/browse/libgames-support/"

LICENSE="LGPL-3+"
SLOT="1/2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.40:2
	dev-libs/libgee:0.8=
	>=x11-libs/gtk+-3.19.2:3
"
DEPEND="${DEPEND}
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure \
		VALAC=$(type -P true)
}
