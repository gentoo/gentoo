# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit toolchain-funcs

DESCRIPTION="A point-to-point bandwidth measurement tool"
SRC_URI="mirror://debian/pool/main/b/bing/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="http://fgouget.free.fr/bing/index-en.shtml"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="amd64 ~arm ia64 ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND=">=sys-apps/sed-4"

src_prepare() {
	sed -i -e "s:#COPTIM = -g: COPTIM = ${CFLAGS}:" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"|| die "emake failed"
}

src_install() {
	dobin bing || die
	doman unix/bing.8 || die
	dodoc ChangeLog Readme.{1st,txt} || die
}
