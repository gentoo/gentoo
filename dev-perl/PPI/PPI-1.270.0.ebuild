# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MITHALDU
DIST_VERSION=1.270
inherit perl-module

DESCRIPTION="Parse, Analyze and Manipulate Perl (without perl)"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Clone-0.300.0
	>=virtual/perl-Digest-MD5-2.350.0
	virtual/perl-Exporter
	virtual/perl-File-Spec
	>=dev-perl/IO-String-1.70.0
	>=virtual/perl-Scalar-List-Utils-1.330.0
	>=dev-perl/Params-Util-1.000.0
	>=virtual/perl-Storable-2.170.0
	dev-perl/Task-Weaken
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Class-Inspector-1.220.0
		virtual/perl-Encode
		>=dev-perl/File-Remove-1.420.0
		virtual/perl-File-Temp
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-NoWarnings
		>=dev-perl/Test-Object-0.70.0
		>=dev-perl/Test-SubCalls-1.70.0
	)
"
