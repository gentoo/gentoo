# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LUKEC
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Mocks LWP::UserAgent"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Test-MockObject
	virtual/perl-Test
"
BDEPEND="${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Module-Metadata
"
