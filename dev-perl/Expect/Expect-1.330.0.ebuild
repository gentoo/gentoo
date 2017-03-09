# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JACOBY
DIST_VERSION=1.33
DIST_EXAMPLES=("examples/*" "tutorial")
inherit perl-module

DESCRIPTION="Expect for Perl"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~sparc ~x86"
IUSE="test minimal"

S="${WORKDIR}/expect.pm-${DIST_P}" # ugh, github

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	virtual/perl-IO
	>=dev-perl/IO-Tty-1.110.0
	!minimal? (
		dev-perl/IO-Stty
	)
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	test? (
		virtual/perl-File-Temp
		virtual/perl-Test-Simple
	)
"
