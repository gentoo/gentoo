# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SALVA
DIST_VERSION=0.22
DIST_EXAMPLES=("benchmarks/*")
inherit perl-module

DESCRIPTION="Manipulate 128 bits integers in Perl"
SLOT="0"
KEYWORDS="~alpha amd64 -arm arm64 ~mips -ppc ppc64 ~riscv ~sparc -x86"

RDEPEND="
	>=dev-perl/Math-Int64-0.510.0
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"

PERL_RM_FILES=(
	"t/author-eol.t"
	"t/author-no-tabs.t"
	"t/author-pod-spell.t"
	"t/release-cpan-changes.t"
	"t/release-pod-syntax.t"
	"t/release-portability.t"
	"t/release-synopsis.t"
)
