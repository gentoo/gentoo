# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="utility to test and create .sfv files and create .par files"
HOMEPAGE="http://pure-sfv.sourceforge.net/"
SRC_URI="mirror://sourceforge/pure-sfv/${PN}_${PV}_src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"
IUSE=""
RESTRICT="test"

DEPEND=""

S="${WORKDIR}"

src_prepare() {
	sed -i Makefile -e "s:-Werror -O2 -g::"
	epatch "${FILESDIR}"/${P}-asneeded.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin pure-sfv || die "dobin failed"
	dodoc ReadMe.txt
}
