# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DCANTRELL
DIST_VERSION=0.64
inherit perl-module

DESCRIPTION="Test strings and data structures and show differences if not ok"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"
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
