# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.203
inherit perl-module

DESCRIPTION="Write-once, read-many attributes for Moose"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=dev-perl/Moose-0.900.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
