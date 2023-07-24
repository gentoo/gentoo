# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

POE_TEST_LOOPS_VERSION=1.360.0
DIST_AUTHOR=BINGOS
DIST_VERSION=1.370
inherit perl-module

DESCRIPTION="Framework for creating multitasking programs in Perl"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="ipv6 libwww ncurses tk"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
	>=virtual/perl-File-Spec-0.870.0
	>=virtual/perl-IO-1.240.0
	>=dev-perl/IO-Pipely-0.5.0
	>=dev-perl/IO-Tty-1.80.0
	>=virtual/perl-Storable-2.160.0
	>=virtual/perl-Time-HiRes-1.590.0
	ipv6? (
		>=dev-perl/Socket6-0.14
	)
	tk? (
		>=dev-perl/Tk-800.027
	)
	libwww? (
		>=dev-perl/libwww-perl-5.79
		>=dev-perl/URI-1.30
	)
	ncurses? (
		>=dev-perl/Curses-1.08
	)
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/POE-Test-Loops-${POE_TEST_LOOPS_VERSION}
		>=virtual/perl-Test-Harness-2.26
		>=virtual/perl-Test-Simple-0.54
	)
"

src_test() {
	perl_rm_files t/10_units/01_pod/01_pod.t    \
		t/10_units/01_pod/02_pod_coverage.t \
		t/10_units/01_pod/03_pod_no404s.t   \
		t/10_units/01_pod/04_pod_linkcheck.t

	# Disable network tests
	rm -f "${S}"/run_network_tests || die
	perl-module_src_test
}
