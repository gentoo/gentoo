# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LEONT
DIST_VERSION=0.014
inherit perl-module

DESCRIPTION="Verify requirements in a CPAN::Meta object"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="test"

# CPAN::Meta::Prereqs -> perl-CPAN-Meta
RDEPEND="
	>=virtual/perl-CPAN-Meta-2.132.830
	>=virtual/perl-CPAN-Meta-Requirements-2.121.0
	virtual/perl-Exporter
	>=virtual/perl-Module-Metadata-1.0.23
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		dev-perl/Test-Deep
		>=virtual/perl-Test-Simple-0.880.0
	)
"
