# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EXODIST
DIST_VERSION=0.000060
inherit perl-module

DESCRIPTION="A rich set of tools built upon the Test2 framework"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Importer-0.10.0
	virtual/perl-Scalar-List-Utils
	>=virtual/perl-Test-Simple-1.302.32
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
