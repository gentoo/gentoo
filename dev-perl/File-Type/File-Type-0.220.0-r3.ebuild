# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PMISON
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Determine file type using magic"

SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~sparc x86"

RDEPEND="
	>=virtual/perl-IO-0.10.0
"

BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		>=virtual/perl-Test-Simple-0.10.0
	)
"
