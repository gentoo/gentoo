# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools eutils

DESCRIPTION="Genomic similarity search with multiple transition constrained spaced seeds"
HOMEPAGE="http://bioinfo.lifl.fr/yass/"
SRC_URI="http://bioinfo.lifl.fr/yass/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="dmalloc lowmem threads"
KEYWORDS="~amd64 ~x86"

DEPEND="dmalloc? ( dev-libs/dmalloc )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-as-needed.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable threads) \
		$(use_enable lowmem lowmemory) \
		$(use_with dmalloc)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README NEWS || die
}
