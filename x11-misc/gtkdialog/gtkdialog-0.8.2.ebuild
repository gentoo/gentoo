# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="A small utility for fast and easy GUI building"
HOMEPAGE="https://code.google.com/p/gtkdialog/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/gtk+:2
	gnome-base/libglade"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/flex
	virtual/yacc"

DOCS=( AUTHORS ChangeLog TODO )

src_install() {
	# Stop make install from running gtk-update-icon-cache
	emake DESTDIR="${D}" UPDATE_ICON_CACHE=true install
}
