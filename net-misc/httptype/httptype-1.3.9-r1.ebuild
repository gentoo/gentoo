# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Returns the http host software of a website"
HOMEPAGE="http://httptype.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="dev-lang/perl"

src_compile() { :; }

src_install() {
	dobin httptype
	doman httptype.1
	dodoc Changelog README
}
