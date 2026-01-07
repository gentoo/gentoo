# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ROKR
DIST_VERSION=0.021
inherit perl-module

DESCRIPTION="An easy-to-use and comprehensive named-color library"

SLOT="0"
KEYWORDS="amd64 x86 ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Module-Pluggable
	dev-perl/Class-Accessor
	dev-perl/Class-Data-Inheritable
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Test-Most
	)
"
