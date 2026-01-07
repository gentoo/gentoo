# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=1.45
inherit perl-module

DESCRIPTION="Perform diffs on files and record sets"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/Algorithm-Diff-1.190.0
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

PERL_RM_FILES=( "t/97_meta.t" "t/98_pod.t" "t/99_pmv.t" )
