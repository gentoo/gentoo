# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/sibsim4/sibsim4-0.20.ebuild,v 1.4 2013/02/17 18:25:16 ago Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="A rewrite and improvement upon sim4, a DNA-mRNA aligner"
HOMEPAGE="http://sibsim4.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/SIBsim4-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/SIBsim4-${PV}"

src_prepare() {
	sed \
		-e 's/CFLAGS = /CFLAGS +=/' \
		-e '/^CC/s:=:?=:' \
		-e '/^OPT/d' \
		-e "s:-o:${LDFLAGS} -o:g" \
		-i "${S}/Makefile" || die
	tc-export CC
}

src_install() {
	dobin SIBsim4
	doman SIBsim4.1
}
