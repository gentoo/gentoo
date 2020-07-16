# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
GENTOO_DEPEND_ON_PERL_SUBSLOT=no
inherit eutils perl-module

DESCRIPTION="Client for Wake-On-LAN"
HOMEPAGE="http://gsd.di.uminho.pt/jpo/software/wakeonlan/"
SRC_URI="http://gsd.di.uminho.pt/jpo/software/wakeonlan/downloads/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-ethers-lookup.patch
	perl-module_src_prepare
}

src_install() {
	perl-module_src_install
	dodoc examples/lab001.wol
}
