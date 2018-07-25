# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EXODIST
DIST_VERSION=0.002
inherit perl-module

DESCRIPTION="Tool for inspecting subroutines"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	>=dev-perl/Importer-0.24.0
"
DEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-1.302.72
	)
"
