# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPS
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Perl interface to GnuPG"

SLOT="0"
KEYWORDS="amd64 ~hppa ppc ~riscv x86"

RDEPEND="
	>=app-crypt/gnupg-1.4
	virtual/perl-autodie
	>=virtual/perl-Math-BigInt-1.780.0
	>=dev-perl/Moo-0.91.11
	>=dev-perl/MooX-HandlesVia-0.1.4
	>=dev-perl/MooX-late-0.14.0
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
"

PATCHES=(
	"${FILESDIR}"/GnuPG-Interface-1.30.0-which-hunt.patch
)

src_test() {
	# Nearly all tests succeed with this patchset and GnuPG 2.1 when running outside the
	# emerge sandbox. However, the agent architecture is not really sandbox-friendly, so...
	#
	# Test Summary Report
	# -------------------
	# t/decrypt.t              (Wstat: 0 Tests: 6 Failed: 2)
	#  Failed tests:  5-6
	# Failed 1/22 test programs. 2/56 subtests failed.
	#perl_rm_files t/decrypt.t

	# Needs to run a setup test that spawns a persistent daemon
	DIST_TEST="do"
	perl-module_src_test
}
