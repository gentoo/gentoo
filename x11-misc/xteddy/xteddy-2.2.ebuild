# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xteddy/xteddy-2.2.ebuild,v 1.8 2014/07/01 12:57:22 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="A cuddly teddy bear (or other image) for your X desktop"
HOMEPAGE="http://webstaff.itn.liu.se/~stegu/xteddy/"
SRC_URI="http://webstaff.itn.liu.se/~stegu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-libs/imlib2[X,png]
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS README ChangeLog NEWS xteddy.README )

src_prepare() {
	epatch "${FILESDIR}"/${P}-linking.patch

	# Fix paths in xtoys script wrt bug #404899
	sed -i -e "s:/usr/games:/usr/bin:" xtoys || die
	eautoreconf
}
