# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=PMISON
DIST_VERSION=0.22
inherit perl-module

DESCRIPTION="Determine file type using magic"

SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-IO-0.10.0
"

BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.280.0
	test? (
		>=virtual/perl-Test-Simple-0.10.0
	)
"
