# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OVID
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Perl extension for easily overriding subroutines"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? (
		>=dev-perl/Test-Fatal-0.10.0
	)
"
