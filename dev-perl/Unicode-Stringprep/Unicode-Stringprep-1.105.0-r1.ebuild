# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CFAERBER
MODULE_VERSION=1.105
inherit perl-module

DESCRIPTION="Preparation of Internationalized Strings (RFC 3454)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Unicode-Normalize-1
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-NoWarnings
	)
"
