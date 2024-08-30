# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ALINKE
DIST_VERSION=0.29
inherit perl-module

DESCRIPTION="Transliterates text between writing systems"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
