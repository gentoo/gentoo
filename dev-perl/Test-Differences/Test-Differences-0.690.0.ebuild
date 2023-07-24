# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DCANTRELL
DIST_VERSION=0.69
inherit perl-module

DESCRIPTION="Test strings and data structures and show differences if not ok"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/Capture-Tiny-0.240.0
	>=virtual/perl-Data-Dumper-2.126.0
	>=dev-perl/Text-Diff-1.430.0
	>=virtual/perl-Test-Simple-0.880.0
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=(
	"t/boilerplate.t"
	"t/pod-coverage.t"
	"t/pod.t"
)
