# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=LEONT
DIST_VERSION=0.012
inherit perl-module

DESCRIPTION='Verify requirements in a CPAN::Meta object'

SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ppc ~ppc64 ~x86"
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
		virtual/perl-File-Spec
		dev-perl/Test-Deep
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.880.0
	)
"
