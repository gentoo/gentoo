# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Client library for fastcgi protocol"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	virtual/perl-IO
	dev-perl/Moo
	dev-perl/Type-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
"
