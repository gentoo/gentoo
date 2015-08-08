# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="utility for generating icon themes and libXcursor cursor themes"
HOMEPAGE="http://www.freedesktop.org/software/icon-slicer/"
SRC_URI="http://www.freedesktop.org/software/icon-slicer/releases/${P}.tar.gz"

KEYWORDS="alpha amd64 ~hppa ia64 ppc sparc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="x11-apps/xcursorgen
	x11-libs/gtk+:2
	dev-libs/popt"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc AUTHORS ChangeLog README TODO
}
