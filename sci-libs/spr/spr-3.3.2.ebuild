# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils autotools

MYP=SPR-${PV}

DESCRIPTION="Statistical analysis and machine learning library"
HOMEPAGE="http://statpatrec.sourceforge.net/"
SRC_URI="mirror://sourceforge/statpatrec/${MYP}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="root static-libs"

DEPEND="root? ( sci-physics/root )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MYP}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-autotools.patch \
		"${FILESDIR}"/${P}-gcc46.patch
	rm aclocal.m4 || die
	eautoreconf
	cp data/gauss* src/
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with root)
}
