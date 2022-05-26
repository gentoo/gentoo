# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=OALDERS
DIST_VERSION=3.31
inherit perl-module

DESCRIPTION="Determine Web browser, version, and platform from an HTTP user agent string"

SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-JSON-PP
		dev-perl/Path-Tiny
		dev-perl/Test-FailWarnings
		virtual/perl-Test-Simple
		dev-perl/Test-Most
		dev-perl/Test-NoWarnings
		dev-perl/Hash-Merge
	)
"

src_test() {
	perl_rm_files t/release-*.t
	perl-module_src_test
}
