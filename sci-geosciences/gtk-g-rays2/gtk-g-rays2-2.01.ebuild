# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/gtk-g-rays2/gtk-g-rays2-2.01.ebuild,v 1.4 2014/07/24 17:59:07 axs Exp $

EAPI=4

inherit autotools gnome2

DESCRIPTION="GUI for accessing the Wintec WBT 201 / G-Rays 2 GPS device"
HOMEPAGE="http://www.daria.co.uk/gps"
SRC_URI="http://www.zen35309.zen.co.uk/gps/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	dev-libs/dbus-glib
	virtual/libgudev
	x11-libs/cairo
	x11-libs/gtk+:3
	virtual/freedesktop-icon-theme
"
DEPEND="${DEPEND}
	virtual/pkgconfig
	sys-devel/gettext
"

DOCS="README AUTHORS ChangeLog"

src_prepare() {
	# werror is bad idea
	sed -i -e 's:-Werror::g' configure.ac || die
	# we run this ourselves
	sed -i -e '/gtk-update-icon-cache/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
}
