# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RSAVAGE
DIST_A_EXT=tgz
DIST_VERSION=1.32
inherit perl-module

DESCRIPTION="(Super)class for representing nodes in a tree"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	>=dev-perl/File-Slurp-Tiny-0.3.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-1.1.2
		>=virtual/perl-File-Spec-3.400.0
		>=virtual/perl-File-Temp-0.190.0
	)
"
