# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BDFOY
DIST_VERSION=1.023
inherit perl-module

DESCRIPTION="Utilities for interactive I/O"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

RDEPEND="
	>=virtual/perl-version-0.780.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? ( >=virtual/perl-Test-Simple-1.0.0 )
"

PERL_RM_FILES=( "t/pod.t" "t/pod-coverage.t" )
