# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=AJUNG
MODULE_VERSION=0.51
inherit perl-module

DESCRIPTION="Parse a X.509 certificate"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Convert-ASN1-0.19
	test? ( >=virtual/perl-Test-Simple-0.96 )
"

SRC_TEST="do"
