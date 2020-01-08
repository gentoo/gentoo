# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=OVID
MODULE_VERSION=0.09
inherit perl-module

DESCRIPTION="Perl extension for easily overriding subroutines"

SLOT="0"
KEYWORDS="amd64 ia64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	test? (
		>=dev-perl/Test-Fatal-0.10.0
	)"

SRC_TEST="do"
