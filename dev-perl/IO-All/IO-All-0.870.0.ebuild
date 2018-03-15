# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=FREW
DIST_VERSION=0.87

inherit perl-module

DESCRIPTION="unified IO operations"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ~sparc x86"
IUSE=""

# needs Scalar::Util
DEPEND="
	virtual/perl-Scalar-List-Utils
"
RDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
