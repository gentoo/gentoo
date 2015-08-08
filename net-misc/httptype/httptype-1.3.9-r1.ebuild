# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Returns the http host software of a website"
HOMEPAGE="http://httptype.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux"

RDEPEND="dev-lang/perl"

src_compile() { :; }

src_install() {
	dobin httptype
	doman httptype.1
	dodoc Changelog README
}
