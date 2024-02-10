# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Extensible perl-based build utility"
HOMEPAGE="https://www.gnu.org/software/cons/"
SRC_URI="https://www.gnu.org/software/${PN}/stable/${P}.tgz
	https://www.gnu.org/software/${PN}/dev/${P}.tgz"

LICENSE="GPL-2"
SLOT="2.2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc x86"

RDEPEND="dev-lang/perl
	virtual/perl-Digest-MD5
	!sci-biology/emboss"
BDEPEND="${RDEPEND}
	app-arch/gzip"

DOCS=( CHANGES INSTALL MANIFEST README RELEASE TODO )

src_install() {
	dobin cons

	docinto html
	dodoc *.html

	gunzip cons.1.gz || die
	doman cons.1
}
