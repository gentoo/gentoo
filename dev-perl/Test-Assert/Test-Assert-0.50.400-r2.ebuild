# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DEXTER
DIST_VERSION=0.0504
inherit perl-module

DESCRIPTION="Assertion methods for those who like JUnit"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/constant-boolean-0.20.0
	>=dev-perl/Exception-Base-0.210.0
	>=dev-perl/Symbol-Util-0.20.200
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	dev-perl/Class-Inspector
	virtual/perl-parent
	>=dev-perl/Test-Unit-Lite-0.110.0
"
