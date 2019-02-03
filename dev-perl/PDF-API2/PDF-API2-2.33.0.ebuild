# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SSIMMS
DIST_VERSION=2.033
DIST_EXAMPLES=( "contrib/*" )
inherit perl-module

DESCRIPTION="Facilitates the creation and modification of PDF files"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="examples test"

RDEPEND="
	>=virtual/perl-IO-Compress-1.0.0
	dev-perl/Font-TTF"
DEPEND="${RDEPEND}
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
