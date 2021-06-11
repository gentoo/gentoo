# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit perl-module

DESCRIPTION="Client for Wake-On-LAN"
HOMEPAGE="https://github.com/jpoliv/wakeonlan/"
SRC_URI="https://github.com/jpoliv/wakeonlan/archive/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="virtual/perl-ExtUtils-MakeMaker"

PATCHES="${FILESDIR}/${P}-ethers-lookup-r1.patch"

src_install() {
	perl-module_src_install
	dodoc examples/lab001.wol
	fperms u+w /usr/bin/wakeonlan /usr/share/man/man1/wakeonlan.1
}
