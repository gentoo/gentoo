# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.15

inherit perl-module

DESCRIPTION="Future-returning IO methods"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Struct-Dumb"
BDEPEND="
	dev-perl/Module-Build
	test? (
		dev-perl/Test-ExpectAndCheck
		dev-perl/Test-Deep
		dev-perl/Test-Future-IO-Impl
		virtual/perl-Test2-Suite
	)
"
