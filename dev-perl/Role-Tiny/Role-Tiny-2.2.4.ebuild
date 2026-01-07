# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=2.002004
inherit perl-module

DESCRIPTION="Roles: a nouvelle cuisine portion size slice of Moose"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	!<dev-perl/Moo-0.9.14
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
