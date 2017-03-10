# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=1.004
inherit perl-module

DESCRIPTION="Minimalist class construction"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
LICENSE="Apache-2.0"
IUSE="test minimal"

RDEPEND="
	virtual/perl-Carp
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	test? (
		!minimal? (
			>=virtual/perl-CPAN-Meta-2.120.900
			dev-perl/Test-FailWarnings
		)
		virtual/perl-Exporter
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
	)
"
