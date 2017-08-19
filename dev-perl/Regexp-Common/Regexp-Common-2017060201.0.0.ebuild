# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

DIST_AUTHOR=ABIGAIL
DIST_VERSION=$(get_major_version)

inherit perl-module

DESCRIPTION="Provide commonly requested regular expressions"

LICENSE="|| ( Artistic Artistic-2 MIT BSD )"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="test"

DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-Regexp )
"
