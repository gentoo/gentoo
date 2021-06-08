# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=TMTM
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Add contextual fetches to DBI"

SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ppc64 sparc x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/DBI-1.37"
BDEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
		dev-perl/DBD-SQLite
	)
"
PERL_RM_FILES=(
	t/pod.t
	t/pod-coverage.t
)
