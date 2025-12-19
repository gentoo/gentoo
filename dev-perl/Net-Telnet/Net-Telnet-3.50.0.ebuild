# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JROGERS
DIST_VERSION=3.05
inherit perl-module

DESCRIPTION="interact with TELNET port or other TCP ports in Perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~sparc x86"

RDEPEND=">=virtual/perl-libnet-1.70.300"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
