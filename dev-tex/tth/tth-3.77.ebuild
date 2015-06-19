# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/tth/tth-3.77.ebuild,v 1.16 2014/11/06 10:58:50 jer Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Translate TEX into HTML"
HOMEPAGE="http://hutchinson.belmont.ma.us/tth/"
SRC_URI="mirror://gentoo/${P}.tgz"

SLOT="0"
LICENSE="free-noncomm"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND="
	app-text/ghostscript-gpl
	media-libs/netpbm"

S="${WORKDIR}/tth_C"

src_compile() {
	echo 'all: tth' > Makefile || die
	tc-export CC
	emake
}

src_install() {
	dobin tth latex2gif ps2gif ps2png
	dodoc CHANGES
	doman tth.1
	dohtml *
}
