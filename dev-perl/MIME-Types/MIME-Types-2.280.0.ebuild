# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=2.28
inherit perl-module

DESCRIPTION="Definition of MIME types"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? ( >=virtual/perl-Test-Simple-0.470.0 )
"
