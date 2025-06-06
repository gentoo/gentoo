# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SRI
DIST_VERSION=9.40
DIST_EXAMPLES=("examples/*")

inherit perl-module

DESCRIPTION="Real-time web framework"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~riscv ~x86"
IUSE="minimal"

RDEPEND="
	!minimal? (
		>=dev-perl/Cpanel-JSON-XS-4.90.0
		>=dev-perl/EV-4.0.0
	)
	>=virtual/perl-IO-Socket-IP-0.370.0
	>=virtual/perl-Scalar-List-Utils-1.410.0
"

PERL_RM_FILES=(
	t/pod.t
	t/pod_coverage.t
)
