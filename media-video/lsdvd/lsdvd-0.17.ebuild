# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Utility for getting info out of DVDs"
HOMEPAGE="http://sourceforge.net/projects/lsdvd/"
SRC_URI="mirror://sourceforge/lsdvd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="media-libs/libdvdread"
DEPEND="${RDEPEND}"
DOCS="AUTHORS README ChangeLog"

src_prepare() {
	rm "${S}/aclocal.m4" "${S}/Makefile.in"
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}
