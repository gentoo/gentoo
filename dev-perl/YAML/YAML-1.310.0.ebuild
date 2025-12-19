# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=INGY
DIST_VERSION=1.31
inherit perl-module

DESCRIPTION="YAML Ain't Markup Language (tm)"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND=""
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Encode
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/Test-YAML-1.50.0
	)
"

PERL_RM_FILES=("t/author-pod-syntax.t")
