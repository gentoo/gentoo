# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=YVES
DIST_VERSION=4.004
inherit perl-module

DESCRIPTION="Fast, compact, powerful binary serialization"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE="test"

# Note: bundled zstd fails compile
RDEPEND="
	virtual/perl-XSLoader
	app-arch/zstd:=
"
# Tester note: ideally you want dev-perl/Sereal-Decoder
# as well, but we can't depend on it because it forms
# a tight cycle if we do
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-7.0.0
	>=virtual/perl-ExtUtils-ParseXS-2.210.0
	virtual/perl-File-Path
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-File-Spec
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Deep
		dev-perl/Test-Differences
		dev-perl/Test-LongString
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warn
	)
"
