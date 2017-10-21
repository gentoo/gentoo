# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAVIDO
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Guess C++ compiler and flags"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Capture-Tiny
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Path
		virtual/perl-Data-Dumper
		virtual/perl-ExtUtils-Manifest
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
		dev-perl/Module-Build
	)
"
PATCHES=( "${FILESDIR}/${P}-no-dot-inc.patch" )
