# Copyright 2003-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="Utility for getting info out of DVDs"
HOMEPAGE="https://sourceforge.net/projects/lsdvd/"
SRC_URI="mirror://sourceforge/lsdvd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="media-libs/libdvdread:0="
DEPEND="${RDEPEND}"
DOCS="AUTHORS README ChangeLog"

src_prepare() {
	rm "${S}/aclocal.m4" "${S}/Makefile.in"
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}
