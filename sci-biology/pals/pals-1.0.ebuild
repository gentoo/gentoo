# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/pals/pals-1.0.ebuild,v 1.3 2009/09/22 14:09:43 maekke Exp $

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Pairwise Aligner for Long Sequences"
HOMEPAGE="http://www.drive5.com/pals/"
#SRC_URI="http://www.drive5.com/pals/pals_source.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_compile() {
	emake GPP="$(tc-getCXX)" CFLAGS="${CXXFLAGS}" || die
}

src_install() {
	dobin pals || die
}
