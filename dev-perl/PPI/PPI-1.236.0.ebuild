# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MITHALDU
DIST_VERSION=1.236
inherit perl-module

DESCRIPTION="Parse, Analyze and Manipulate Perl (without perl)"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ~ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Clone-0.300.0
	>=virtual/perl-Digest-MD5-2.350.0
	>=virtual/perl-File-Spec-3.270.100
	>=dev-perl/IO-String-1.70.0
	>=dev-perl/List-MoreUtils-0.160.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
	>=dev-perl/Params-Util-1.000.0
	>=virtual/perl-Storable-2.170.0
	dev-perl/Task-Weaken
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		>=dev-perl/Class-Inspector-1.220.0
		>=dev-perl/File-Remove-1.420.0
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.860.0
		>=dev-perl/Test-Object-0.70.0
		>=dev-perl/Test-SubCalls-1.70.0
	)
"
