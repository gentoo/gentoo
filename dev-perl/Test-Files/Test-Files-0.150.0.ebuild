# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JSF
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="A Test::Builder based module to ease testing with files and dirs"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Algorithm-Diff
	virtual/perl-Test-Simple
	dev-perl/Text-Diff
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
