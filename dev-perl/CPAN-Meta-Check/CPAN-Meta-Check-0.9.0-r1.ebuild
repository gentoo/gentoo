# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=LEONT
MODULE_VERSION=0.009
inherit perl-module

DESCRIPTION='Verify requirements in a CPAN::Meta object'

SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~x86"
IUSE="test"

# CPAN::Meta::Prereqs -> perl-CPAN-Meta
RDEPEND="
	>=virtual/perl-CPAN-Meta-2.132.830
	>=virtual/perl-CPAN-Meta-Requirements-2.121.0
	>=virtual/perl-Exporter-5.570.0
	virtual/perl-Module-Metadata
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

SRC_TEST="do"
