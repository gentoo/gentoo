# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="Line breaking library"
HOMEPAGE="http://vimgadgets.sourceforge.net/liblinebreak/"
SRC_URI="mirror://sourceforge/vimgadgets/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE="static-libs"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
