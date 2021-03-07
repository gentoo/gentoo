# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETJ
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Guess C++ compiler and flags"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Capture-Tiny
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		virtual/perl-Data-Dumper
		virtual/perl-ExtUtils-Manifest
		virtual/perl-File-Spec
		dev-perl/Module-Build
		>=virtual/perl-Test-Simple-0.880.0
		virtual/perl-autodie
	)
"
