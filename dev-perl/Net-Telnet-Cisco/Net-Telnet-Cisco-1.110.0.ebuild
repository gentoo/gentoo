# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=VINSWORLD
DIST_VERSION=1.11
inherit perl-module

DESCRIPTION="Automate telnet sessions w/ routers&switches"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc ppc64 sparc x86"
IUSE="test"

RDEPEND=">=dev-perl/Net-Telnet-3.20.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/TermReadKey )
"
PATCHES=( "${FILESDIR}/${PN}-1.11-no-interactive-test.patch" )
PERL_RM_FILES=( "t/02-pod-coverage.t" )

src_test() {
	if [[ -z $CISCO_TEST_ROUTER ]]; then
		elog "Comprehensive testing requires a configured, network accessible Cisco Router"
		elog "to test against. For details, see:"
		elog "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
	perl-module_src_test
}
