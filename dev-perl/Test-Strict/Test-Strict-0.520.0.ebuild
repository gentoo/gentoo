# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MANWAR
DIST_VERSION=0.52
inherit perl-module

DESCRIPTION="Check syntax, presence of use strict; and test coverage"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=virtual/perl-File-Spec-0.10.0
	>=virtual/perl-File-Temp-0.10.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/IO-stringy
		>=virtual/perl-Test-Simple-1.0.0
	)
"
