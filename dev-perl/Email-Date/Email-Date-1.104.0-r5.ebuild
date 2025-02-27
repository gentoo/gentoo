# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.104
inherit perl-module

DESCRIPTION="Find and Format Date Headers"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"

RDEPEND="
	>=dev-perl/Email-Abstract-2.13.1
	>=dev-perl/Email-Date-Format-1.0.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-Time-Local
		dev-perl/Capture-Tiny
		>=virtual/perl-Test-Simple-0.960.0
	)
"
