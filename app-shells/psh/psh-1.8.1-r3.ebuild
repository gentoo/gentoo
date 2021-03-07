# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_EXAMPLES=( "examples/*" )

inherit perl-module

DESCRIPTION="Combines the interactive nature of a Unix shell with the power of Perl"
HOMEPAGE="https://gnp.github.io/psh/"
SRC_URI="https://github.com/gnp/psh/archive/${P}.tar.gz -> ${PF}.tar.gz"
S="${WORKDIR}/${PN}-${P}" # github--

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="readline"

RDEPEND="
	readline? (
		dev-perl/Term-ReadLine-Gnu
		dev-perl/TermReadKey
	)
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

myinst="SITEPREFIX=${D}/usr"

PATCHES=(
	"${FILESDIR}/${PF}-defined-array.patch"
	"${FILESDIR}/${PF}-array-ref-deprecated.patch"
)

src_install() {
	perl-module_src_install
	docompress -x "/usr/share/doc/${PF}/pod"
	docinto pod/
	dodoc -r doc/*
}
