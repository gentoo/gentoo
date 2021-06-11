# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=WYANT
DIST_VERSION=0.017
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Parse Perl string literals and string-literal-like things"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64"
IUSE="test examples"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-Exporter
	>=dev-perl/PPI-1.117.0
	dev-perl/PPIx-Regexp
	dev-perl/Readonly
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
