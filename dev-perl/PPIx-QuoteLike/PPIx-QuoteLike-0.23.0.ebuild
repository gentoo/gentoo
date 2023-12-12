# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=WYANT
DIST_VERSION=0.023
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Parse Perl string literals and string-literal-like things"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Encode
	virtual/perl-Exporter
	virtual/perl-Scalar-List-Utils
	>=dev-perl/PPI-1.238.0
	dev-perl/PPIx-Regexp
	dev-perl/Readonly
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
