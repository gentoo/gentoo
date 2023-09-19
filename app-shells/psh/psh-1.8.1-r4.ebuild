# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_EXAMPLES=( "examples/*" )

inherit optfeature perl-module

DESCRIPTION="Combines the interactive nature of a Unix shell with the power of Perl"
HOMEPAGE="https://gnp.github.io/psh/"
SRC_URI="https://github.com/gnp/psh/archive/${P}.tar.gz"
S="${WORKDIR}"/${PN}-${P}

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="readline"

RDEPEND="
	readline? (
		dev-perl/Term-ReadLine-Gnu
		dev-perl/TermReadKey
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/perl-ExtUtils-MakeMaker"

PATCHES=(
	"${FILESDIR}"/${P}-r3-defined-array.patch
	"${FILESDIR}"/${P}-r3-array-ref-deprecated.patch
)

src_install() {
	myinst="SITEPREFIX=${D}/usr"

	perl-module_src_install

	docompress -x /usr/share/doc/${PF}/pod

	docinto pod/
	dodoc -r doc/*
}

pkg_postinst() {
	optfeature "ulimit functionality" dev-perl/BSD-Resource
}
