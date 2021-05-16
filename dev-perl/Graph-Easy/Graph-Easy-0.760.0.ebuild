# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.76
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Convert or render graphs (as ASCII, HTML, SVG or via Graphviz)"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.130.0
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.0
	test? (
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.620.0
	)
"
PERL_RM_FILES=(
	"t/style-trailing-space.t"
	"t/pod.t"
	"t/pod_cov.t"
)
