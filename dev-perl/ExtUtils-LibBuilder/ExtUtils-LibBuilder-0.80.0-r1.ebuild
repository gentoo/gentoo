# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=AMBS
DIST_VERSION=0.08

inherit perl-module

DESCRIPTION="Tool to build C libraries"
# https://rt.cpan.org/Ticket/Display.html?id=133195
LICENSE="|| ( Artistic GPL-1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-ExtUtils-CBuilder-0.230.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=(
	"t/pod.t"
	"t/pod-coverage.t"
)
