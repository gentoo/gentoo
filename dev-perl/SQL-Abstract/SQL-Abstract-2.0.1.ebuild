# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSTROUT
DIST_VERSION=2.000001
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Generate SQL from Perl data structures"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos ~x86-solaris"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	>=dev-perl/Hash-Merge-0.120.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/MRO-Compat-0.120.0
	>=dev-perl/Moo-2.0.1
	>=dev-perl/Sub-Quote-2.0.1
	>=dev-perl/Test-Deep-0.101.0
	>=virtual/perl-Text-Balanced-2.0.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Data-Dumper-Concise
		virtual/perl-Storable
		>=dev-perl/Test-Exception-0.310.0
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warn
	)
"
