# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ATOOMIC
DIST_VERSION=0.007
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Additional B helpers to check COW status"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		virtual/perl-Test-Simple
		virtual/perl-XSLoader
	)
"
