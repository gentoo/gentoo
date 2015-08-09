# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="A library for manipulating MacOS X .icns icon format"
HOMEPAGE="http://sourceforge.net/projects/icns/"
SRC_URI="mirror://sourceforge/icns/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

RDEPEND=">=media-libs/libpng-1.2:0
	media-libs/jasper"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog DEVNOTES README TODO"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	rm -f "${ED}"usr/lib*/lib*.la
}
