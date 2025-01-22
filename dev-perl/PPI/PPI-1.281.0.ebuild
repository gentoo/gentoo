# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MITHALDU
DIST_VERSION=1.281
inherit perl-module

DESCRIPTION="Parse, Analyze, and Manipulate Perl (without perl)"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Clone-0.300.0
	>=virtual/perl-Digest-MD5-2.350.0
	virtual/perl-Exporter
	virtual/perl-File-Spec
	dev-perl/Safe-Isa
	>=virtual/perl-Scalar-List-Utils-1.330.0
	virtual/perl-parent
	>=dev-perl/Params-Util-1.000.0
	>=virtual/perl-Storable-2.170.0
	dev-perl/Task-Weaken
	dev-perl/YAML-PP
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Class-Inspector-1.220.0
		virtual/perl-Encode
		>=dev-perl/File-Remove-1.420.0
		virtual/perl-File-Temp
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-NoWarnings
		>=dev-perl/Test-Object-0.70.0
		>=dev-perl/Test-SubCalls-1.70.0
	)
"
