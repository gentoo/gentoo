# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit toolchain-funcs eutils

MY_P="${PN}-19980713"

DESCRIPTION="Utility for creating Czech/Slovak-sorted LaTeX index-files"
HOMEPAGE="http://math.feld.cvut.cz/olsak/cstex/"
SRC_URI="ftp://math.feld.cvut.cz/pub/cstex/base/${MY_P}.tar.gz"

LICENSE="MakeIndex"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-flags.patch" \
		"${FILESDIR}/${P}-decl.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "make failed"
}

src_install() {
	dobin csindex || die
	dodoc README
}
