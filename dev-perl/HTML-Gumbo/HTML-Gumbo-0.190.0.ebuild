# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPS
DIST_VERSION=0.19
inherit perl-module

DESCRIPTION="HTML5 parser based on gumbo C library"

SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-perl/Alien-LibGumbo-0.30.0
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
