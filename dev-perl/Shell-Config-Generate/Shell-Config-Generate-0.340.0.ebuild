# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PLICEASE
DIST_VERSION=0.34
inherit perl-module

DESCRIPTION="Portably generate config for any shell"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

RDEPEND="
	dev-perl/Shell-Guess
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test2-Suite-0.0.60
		>=virtual/perl-Test-Simple-1.302.15
	)
"
