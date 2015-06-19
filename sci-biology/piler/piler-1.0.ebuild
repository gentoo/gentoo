# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/piler/piler-1.0.ebuild,v 1.4 2009/09/22 14:11:04 maekke Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Analysis of repetitive DNA found in genome sequences"
HOMEPAGE="http://www.drive5.com/piler/"
#SRC_URI="http://www.drive5.com/piler/piler_source.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( sci-biology/muscle
	sci-libs/libmuscle )
	sci-biology/pals"

S=${WORKDIR}

src_prepare() {
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
}

src_compile() {
	emake GPP="$(tc-getCXX)" CFLAGS="${CXXFLAGS}" || die
}

src_install() {
	dobin piler
}
