# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EXODIST
DIST_VERSION=0.000077
inherit perl-module

DESCRIPTION="A rich set of tools built upon the Test2 framework"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Importer-0.24.0
	virtual/perl-Scalar-List-Utils
	>=dev-perl/Sub-Info-0.1.0
	>=dev-perl/Term-Table-0.2.0
	>=virtual/perl-Test-Simple-1.302.73
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
