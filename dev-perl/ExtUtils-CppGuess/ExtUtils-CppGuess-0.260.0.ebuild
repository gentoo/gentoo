# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=0.26
inherit perl-module

DESCRIPTION="Guess C++ compiler and flags"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	dev-perl/Capture-Tiny
	>=virtual/perl-ExtUtils-ParseXS-3.350.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		>=virtual/perl-ExtUtils-CBuilder-0.280.231
		virtual/perl-ExtUtils-Manifest
		dev-perl/Module-Build
		>=virtual/perl-Test-Simple-0.880.0
	)
"
