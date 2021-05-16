# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Extensible perl-based build utility"
HOMEPAGE="https://www.gnu.org/software/cons/"
SRC_URI="https://www.gnu.org/software/${PN}/stable/${P}.tgz
	https://www.gnu.org/software/${PN}/dev/${P}.tgz"

SLOT="2.2"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ppc ~sparc x86"
IUSE=""

DEPEND="
	dev-lang/perl
	virtual/perl-Digest-MD5"
RDEPEND="
	${DEPEND}
	!sci-biology/emboss"

src_install() {
	dobin cons
	dodoc CHANGES INSTALL MANIFEST README RELEASE TODO
	docinto html
	dodoc *.html
	doman cons.1.gz
}
