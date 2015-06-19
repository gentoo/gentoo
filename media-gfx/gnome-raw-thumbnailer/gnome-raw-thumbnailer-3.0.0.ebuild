# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gnome-raw-thumbnailer/gnome-raw-thumbnailer-3.0.0.ebuild,v 1.6 2012/05/05 07:00:24 jdhore Exp $

EAPI=4
GCONF_DEBUG=no
inherit gnome2

MY_P=${PN/gnome-}-${PV}

DESCRIPTION="A lightweight and fast raw image thumbnailer for GNOME"
HOMEPAGE="http://libopenraw.freedesktop.org/wiki/RawThumbnailer"
SRC_URI="http://libopenraw.freedesktop.org/download/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=media-libs/libopenraw-0.0.9[gtk]
	>=x11-libs/gdk-pixbuf-2
	>=dev-libs/glib-2.26
	!media-gfx/raw-thumbnailer"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS"
}
