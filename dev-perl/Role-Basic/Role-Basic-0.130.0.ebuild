# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=OVID
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Just roles. Nothing else"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
