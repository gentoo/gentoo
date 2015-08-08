# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome2 eutils

DESCRIPTION="Tethered Camera Control & Capture"
HOMEPAGE="http://entangle-photo.org/"
SRC_URI="http://entangle-photo.org/download/sources/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-libs/glib-2.26:2
	>=x11-libs/gdk-pixbuf-2.12.0:2
	>=x11-libs/gtk+-3.3.18:3[introspection]
	virtual/libgudev:=
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/gobject-introspection-0.9.3
	>=media-libs/libgphoto2-2.4.11:=
	media-libs/lcms:2
	>=dev-libs/libpeas-1.2.0[gtk]
	>=media-libs/gexiv2-0.4[introspection]
	>=x11-libs/libXext-1.3.0
	>=x11-themes/gnome-icon-theme-symbolic-3.0.0
	>=media-libs/libraw-0.9.0"
RDEPEND="${DEPEND}"
DEPEND+="
	virtual/pkgconfig"

G2CONF+="
	--disable-maintainer-mode
	--docdir=/usr/share/doc/${PF}
	--htmldir=/usr/share/doc/${PF}/html
	--disable-werror
	--disable-static"

DOCS=( AUTHORS ChangeLog NEWS README )
