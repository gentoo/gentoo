# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=3.38
inherit perl-module

DESCRIPTION="Determine Web browser, version, and platform from an HTTP user agent string"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~mips ppc x86"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		dev-perl/Hash-Merge
		>=virtual/perl-JSON-PP-4.40.0
		>=virtual/perl-Scalar-List-Utils-1.490.0
		dev-perl/Path-Tiny
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-NoWarnings
		dev-perl/Test-Warnings
	)
"

src_test() {
	perl_rm_files t/release-*.t
	perl-module_src_test
}
