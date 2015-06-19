# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/letterize/letterize-1.3.ebuild,v 1.1 2011/08/22 09:47:05 radhermit Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Generate English-plausible alphabetic mnemonics for a phone number"
HOMEPAGE="http://www.catb.org/~esr/letterize/"
SRC_URI="http://www.catb.org/~esr/letterize/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	tc-export CC
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	dodoc README
}
