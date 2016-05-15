# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RCAPUTO
DIST_VERSION=1.023
inherit perl-module

DESCRIPTION="Bind lexicals to persistent data"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="test"

# constant -> perl
RDEPEND="
	>=dev-perl/PadWalker-1.960.0
	>=dev-perl/Devel-LexAlias-0.50.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Carp-1.260.0
		>=virtual/perl-Scalar-List-Utils-1.290.0
		>=virtual/perl-Test-Simple-0.980.0
	)
"
src_test() {
	perl_rm_files "t/02_pod.t" "t/03_pod_coverage.t" "t/release-pod-coverage.t" "t/release-pod-syntax.t"
	perl-module_src_test
}
