# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GFUJI
DIST_VERSION=0.15
DIST_EXAMPLES=( "example/*" "benchmark" )
inherit perl-module

DESCRIPTION="Lightweight field hash for inside-out objects"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-XSLoader-0.20.0
	>=virtual/perl-parent-0.221.0
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="${RDEPEND}
	>=virtual/perl-Devel-PPPort-3.190.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=virtual/perl-ExtUtils-ParseXS-2.210.0
	>=dev-perl/Module-Build-0.400.500
	test? (
		>=dev-perl/Test-LeakTrace-0.70.0
		>=virtual/perl-Test-Simple-0.620.0
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.15-no-dot-inc.patch"
)
src_configure() {
	unset LD;
	if [[ -n "${CCLD}" ]]; then
		export LD="${CCLD}"
	fi
	perl-module_src_configure
}
src_compile() {
	./Build --config optimize="${CFLAGS}" build || die
}
