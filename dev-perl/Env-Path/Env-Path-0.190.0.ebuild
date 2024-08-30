# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DSB"
DIST_VERSION="0.19"
inherit perl-module

DESCRIPTION="Advanced operations on path variables"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc64 ~riscv ~sparc x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
