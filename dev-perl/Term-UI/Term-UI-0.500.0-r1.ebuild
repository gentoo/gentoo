# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BINGOS
DIST_VERSION=0.50
inherit perl-module

DESCRIPTION="User interfaces via Term::ReadLine made easy"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Log-Message-Simple
	virtual/perl-Params-Check
	virtual/perl-Term-ReadLine
	virtual/perl-if
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.310.0
	)
"
