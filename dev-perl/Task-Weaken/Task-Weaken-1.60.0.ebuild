# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Ensure that a platform has weaken support"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-File-Spec
	test? (
		virtual/perl-Scalar-List-Utils
		virtual/perl-Test-Simple
	)
"
