# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/fslurp/fslurp-2.1.4.ebuild,v 1.1 2013/12/23 17:48:15 radhermit Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Read and display data from Fronius IG and IG Plus inverters"
HOMEPAGE="http://fslurp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	emake CC="$(tc-getCXX)"
}

src_install() {
	dobin ${PN}
	dodoc History README TODO
}
