# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DEXTER
DIST_VERSION=0.11
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Exception class for system or library calls"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Exception-Base-0.22.01
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=dev-perl/Test-Unit-Lite-0.100.0
	)
"
PERL_RM_FILES=(
	"t/pod_coverage.t"
	"t/pod.t"
)
