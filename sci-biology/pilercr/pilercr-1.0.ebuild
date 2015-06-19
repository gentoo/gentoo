# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/pilercr/pilercr-1.0.ebuild,v 1.6 2012/04/26 16:39:58 jlec Exp $

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="Analysis of Clustered Regularly Interspaced Short Palindromic Repeats (CRISPRs)"
HOMEPAGE="http://www.drive5.com/pilercr/"
#SRC_URI="http://www.drive5.com/pilercr/pilercr.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc43.patch
}

src_compile() {
	emake GPP="$(tc-getCXX)" CFLAGS="${CXXFLAGS}"
}

src_install() {
	dobin ${PN}
}
