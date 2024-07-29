# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOKUHIROM
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Faster implementation of HTTP::Headers"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-perl/HTTP-Date
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-Requires
	)
"
