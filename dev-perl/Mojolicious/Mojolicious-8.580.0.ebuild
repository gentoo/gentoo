# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SRI
DIST_VERSION=8.58
DIST_EXAMPLES=("examples/*")
inherit perl-module
LICENSE="Artistic-2"
DESCRIPTION="Real-time web framework"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test minimal"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		>=dev-perl/Cpanel-JSON-XS-4.90.0
		>=dev-perl/EV-4.0.0
	)
	>=virtual/perl-IO-Socket-IP-0.370.0
	>=virtual/perl-Scalar-List-Utils-1.410.0
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
