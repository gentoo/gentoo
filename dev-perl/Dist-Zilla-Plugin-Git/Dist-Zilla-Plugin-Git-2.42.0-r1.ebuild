# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=2.042
inherit perl-module

DESCRIPTION="Update your git repository after release"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/DateTime
	>=dev-perl/Dist-Zilla-4.200.16
	dev-perl/Dist-Zilla-Plugin-Config-Git
	>=dev-perl/File-HomeDir-0.810.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/File-chdir
	>=dev-perl/Git-Wrapper-0.21.0
	dev-perl/IPC-System-Simple
	>=virtual/perl-Scalar-List-Utils-1.450.0
	dev-perl/Module-Runtime
	dev-perl/Moose
	dev-perl/MooseX-Has-Sugar
	dev-perl/MooseX-Types
	>=dev-perl/MooseX-Types-Path-Tiny-0.10.0
	>=dev-perl/Path-Tiny-0.48.0
	dev-perl/String-Formatter
	dev-perl/Try-Tiny
	dev-perl/Version-Next
	>=dev-perl/namespace-autoclean-0.90.0
	>=virtual/perl-version-0.80.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Text-ParseWords
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
		virtual/perl-CPAN-Meta-Requirements
		dev-perl/Devel-SimpleTrace
		virtual/perl-Encode
		virtual/perl-Exporter
		dev-perl/File-Copy-Recursive
		>=virtual/perl-File-Path-2.70.0
		virtual/perl-File-Spec
		dev-perl/File-Which
		dev-perl/File-pushd
		dev-perl/Log-Dispatchouli
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.880.0
	)
"
