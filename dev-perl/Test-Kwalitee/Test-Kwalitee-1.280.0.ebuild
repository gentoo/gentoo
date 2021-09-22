# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETHER
DIST_VERSION=1.28
inherit perl-module

DESCRIPTION="Test the Kwalitee of a distribution before you release it"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	virtual/perl-Exporter
	>=dev-perl/Module-CPANTS-Analyse-0.920.0
	>=virtual/perl-Test-Simple-0.880.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/CPAN-Meta-Check-0.11.0
		virtual/perl-CPAN-Meta-Requirements
		virtual/perl-File-Spec
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.960.0
		>=dev-perl/Test-Warnings-0.9.0
		virtual/perl-if
	)
"
