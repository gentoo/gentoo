# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=1.09
inherit perl-module

DESCRIPTION="Module for portable testing of commands and scripts"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc x86"

BDEPEND="virtual/perl-ExtUtils-MakeMaker"
