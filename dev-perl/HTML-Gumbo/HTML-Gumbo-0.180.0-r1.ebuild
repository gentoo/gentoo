# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RUZ
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="HTML5 parser based on gumbo C library"

SLOT="0"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=dev-perl/Alien-LibGumbo-0.30.0
	virtual/perl-XSLoader
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	virtual/perl-ExtUtils-CBuilder
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
