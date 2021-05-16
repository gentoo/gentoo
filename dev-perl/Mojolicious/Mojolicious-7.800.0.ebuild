# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SRI
DIST_VERSION=7.80
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Real-time web framework"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		>=dev-perl/EV-4.0.0
	)
	>=virtual/perl-IO-Socket-IP-0.370.0
	>=virtual/perl-JSON-PP-2.271.30
	>=virtual/perl-Pod-Simple-3.90.0
	>=virtual/perl-Time-Local-1.200.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	t/pod.t
	t/pod_coverage.t
)
