# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/otter/otter-3.3-r2.ebuild,v 1.3 2014/08/10 20:23:55 slyfox Exp $

EAPI=4

inherit eutils

DESCRIPTION="An Automated Deduction System"
HOMEPAGE="http://www.cs.unm.edu/~mccune/otter/"
SRC_URI="http://www.cs.unm.edu/~mccune/otter/${P}.tar.gz"

KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
LICENSE="otter"
SLOT="0"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-gold.patch
}

src_compile() {
	cd source
	CC=$(tc-getCC) emake
	cd "${S}"/mace2
	CC=$(tc-getCC) emake
}

src_install() {
	dobin bin/* source/formed/formed
	dodoc README* Legal Changelog Contents
	insinto /usr/share/doc/${PF}
	doins documents/*.pdf
	insinto /usr/share/${PN}/
	doins -r examples examples-mace2
}
