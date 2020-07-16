# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.14

inherit perl-module

DESCRIPTION="Domain and host name validation"

SLOT="0"
KEYWORDS="amd64 hppa sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Exporter
	>=dev-perl/Net-Domain-TLD-1.740.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-1.302.15
		dev-perl/Test2-Suite
	)
"
