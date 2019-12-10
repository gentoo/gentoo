# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.017
inherit perl-module

DESCRIPTION="Temporary directories that stick around when tests fail"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
	>=virtual/perl-File-Path-2.70.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		>=dev-perl/Capture-Tiny-0.120.0
		virtual/perl-Test-Simple
	)
"
