# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/snpfile/snpfile-2.0.1.ebuild,v 1.3 2009/07/26 18:33:52 ssuominen Exp $

EAPI=2
inherit eutils

DESCRIPTION="A library and API for manipulating large SNP datasets"
HOMEPAGE="http://www.birc.au.dk/~mailund/SNPFile/"
SRC_URI="http://www.birc.au.dk/~mailund/SNPFile/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

RDEPEND="dev-libs/boost"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc44.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
