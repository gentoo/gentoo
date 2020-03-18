# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=EWILHELM
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="Vectors for perl"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"
