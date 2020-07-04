# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MATEU
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Moo types for numbers"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/MooX-Types-MooseLike-0.230.0
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Moo-1.4.2
		>=dev-perl/Test-Fatal-0.3.0
		>=virtual/perl-Test-Simple-0.96
	)
"
