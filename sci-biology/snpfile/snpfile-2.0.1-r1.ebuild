# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/snpfile/snpfile-2.0.1-r1.ebuild,v 1.5 2012/01/15 15:31:51 phajdan.jr Exp $

EAPI=4

inherit autotools eutils multilib

DESCRIPTION="A library and API for manipulating large SNP datasets"
HOMEPAGE="http://www.birc.au.dk/~mailund/SNPFile/"
SRC_URI="http://www.birc.au.dk/~mailund/SNPFile/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="static-libs"
KEYWORDS="amd64 x86"

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-gcc44.patch \
		"${FILESDIR}"/${P}-gentoo.diff \
		"${FILESDIR}"/${P}-gold.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || rm "${D}"/usr/$(get_libdir)/lib${PN}.la
}
