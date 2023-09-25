# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=0.101083
inherit perl-module

DESCRIPTION="does your code require newer perl than you think?"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-CPAN-Meta
	virtual/perl-Exporter
	dev-perl/File-Find-Rule
	dev-perl/File-Find-Rule-Perl
	>=dev-perl/Perl-MinimumVersion-1.320.0
	>=virtual/perl-Test-Simple-0.960.0
	>=virtual/perl-version-0.700.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		virtual/perl-File-Spec
	)
"
