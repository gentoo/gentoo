# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.018
inherit perl-module

DESCRIPTION="Temporary directories that stick around when tests fail"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
	>=virtual/perl-File-Path-2.70.0
	virtual/perl-File-Spec
	>=virtual/perl-File-Temp-0.230.800
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		>=dev-perl/Capture-Tiny-0.120.0
		virtual/perl-Test-Simple
	)
"
