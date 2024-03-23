# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=VEESH
DIST_VERSION=1.63
inherit perl-module

DESCRIPTION="Manipulate structured data definitions (SQL and more)"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~x86"

RDEPEND="
	dev-perl/Carp-Clan
	>=dev-perl/DBI-1.540.0
	virtual/perl-Digest-SHA
	>=dev-perl/File-ShareDir-1.0.0
	>=dev-perl/Moo-1.0.3
	>=dev-perl/Package-Variant-1.1.1
	>=dev-perl/Parse-RecDescent-1.967.9
	virtual/perl-Scalar-List-Utils
	dev-perl/Sub-Quote
	>=dev-perl/Try-Tiny-0.40.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	dev-perl/File-ShareDir-Install
	>=dev-perl/JSON-2
	test? (
		>=dev-perl/JSON-MaybeXS-1.3.3
		dev-perl/Test-Differences
		>=dev-perl/Test-Exception-0.310.0
		>=virtual/perl-Test-Simple-0.880.0
		>=dev-perl/XML-Writer-0.500.0
		>=dev-perl/YAML-0.660.0
	)
"
