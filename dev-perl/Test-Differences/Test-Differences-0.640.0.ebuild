# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DCANTRELL
DIST_VERSION=0.64
inherit perl-module

DESCRIPTION="Test strings and data structures and show differences if not ok"

SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="test"
PERL_RM_FILES=(
	"t/boilerplate.t"
	"t/pod-coverage.t"
	"t/pod.t"
)
RDEPEND="
	>=dev-perl/Text-Diff-1.430.0
	>=virtual/perl-Data-Dumper-2.126.0"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		>=dev-perl/Capture-Tiny-0.240.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
