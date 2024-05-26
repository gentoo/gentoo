# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="expect/check-style unit testing with object methods"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Future
	dev-perl/Test-Deep
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.400.400
	test? (
		virtual/perl-Test2-Suite
	)
"
