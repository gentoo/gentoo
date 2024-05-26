# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.15

inherit perl-module

DESCRIPTION="Domain and host name validation"

SLOT="0"
KEYWORDS="amd64 ~hppa sparc x86"

RDEPEND="
	virtual/perl-Exporter
	>=dev-perl/Net-Domain-TLD-1.740.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-1.302.15
		virtual/perl-Test2-Suite
	)
"
