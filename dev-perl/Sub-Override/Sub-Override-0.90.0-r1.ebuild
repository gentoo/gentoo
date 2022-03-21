# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OVID
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Perl extension for easily overriding subroutines"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~ia64 ppc ~ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		>=dev-perl/Test-Fatal-0.10.0
	)
"
