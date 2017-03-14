# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ALEXMV
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="RFC close address list parsing"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Email-Address
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"
