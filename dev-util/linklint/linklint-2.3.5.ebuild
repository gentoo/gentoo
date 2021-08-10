# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Perl program that checks links on web sites"
HOMEPAGE="http://www.linklint.org/"
SRC_URI="http://www.linklint.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="dev-lang/perl"

src_install() {
	newbin ${P} ${PN}
	dodoc INSTALL.unix INSTALL.windows READ_ME.txt CHANGES.txt

	docinto html
	dodoc -r doc/*
}
