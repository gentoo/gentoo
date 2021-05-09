# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=WYANT
DIST_VERSION=0.080
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Represent a regular expression of some sort"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="test examples"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-Exporter
	dev-perl/List-MoreUtils
	>=dev-perl/PPI-1.117.0
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
