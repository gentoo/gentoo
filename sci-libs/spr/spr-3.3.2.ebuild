# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/spr/spr-3.3.2.ebuild,v 1.2 2012/08/03 22:37:37 bicatali Exp $

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
