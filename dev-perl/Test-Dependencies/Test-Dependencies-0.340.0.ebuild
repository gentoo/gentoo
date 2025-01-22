# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EHUELS
DIST_VERSION=0.34
inherit perl-module

DESCRIPTION="Ensure that your dependency listing is complete"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-CPAN-Meta
	dev-perl/File-Find-Rule-Perl
	>=virtual/perl-Module-CoreList-5.202.6.200
	dev-perl/Pod-Strip
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-CPAN-Meta-Requirements-2.120.620
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Module-Metadata
	test? (
		>=virtual/perl-Test-Simple-1.300.0
		dev-perl/Test-Needs
	)
"
