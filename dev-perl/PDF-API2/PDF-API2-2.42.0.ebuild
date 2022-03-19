# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SSIMMS
DIST_VERSION=2.042
DIST_EXAMPLES=( "contrib/*" )
inherit perl-module

DESCRIPTION="Facilitates the creation and modification of PDF files"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND="
	>=virtual/perl-IO-Compress-1.0.0
	dev-perl/Font-TTF
"

BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Memory-Cycle
	)
"

src_test() {
	perl_rm_files t/author-*.t
	perl-module_src_test
}
