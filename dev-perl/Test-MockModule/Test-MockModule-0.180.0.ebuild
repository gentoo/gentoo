# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_VERSION=v${PV}
DIST_AUTHOR=GFRANKS
inherit perl-module

DESCRIPTION="Override subroutines in a module for unit testing"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/SUPER-1.200.0
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.423.400
	test? (
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warnings
	)
"

PERL_RM_FILES=( "t/pod_coverage.t" "t/pod.t" )
