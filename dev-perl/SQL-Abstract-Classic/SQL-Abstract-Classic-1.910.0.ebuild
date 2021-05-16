# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RIBASUSHI
DIST_VERSION=1.91
inherit perl-module

DESCRIPTION="Generate SQL from Perl data structures with backwards/forwards compat"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Exporter-5.570.0
	>=dev-perl/MRO-Compat-0.120.0
	>=dev-perl/SQL-Abstract-1.790.0
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Text-Balanced-2.0.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	test? (
		virtual/perl-Storable
		>=dev-perl/Test-Deep-0.101.0
		>=dev-perl/Test-Exception-0.310.0
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warn
	)
"
