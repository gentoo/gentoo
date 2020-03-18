# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=NEILB
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="get the full path to a locally installed module"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
# r: Cwd -> File-Spec
# r: File::Basename -> perl
# r: Pod::Usage -> perl
# r: strict, warnings -> perl
RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Exporter
	virtual/perl-Getopt-Long
"
# t: File::Spec::Functions -> File-Spec
# t: FindBin 0.05 -> perl
# t: Test::More -> Test-Simple
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Devel-FindPerl
		>=virtual/perl-Test-Simple-0.880.0
	)
"
