# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
