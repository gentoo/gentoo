# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FERREIRA
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Convert byte count to human readable format"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=( "t/90pod.t" "t/98pod-coverage.t" )
