# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_SECTION=lwp
DIST_AUTHOR=SAXJAZMAN
DIST_VERSION=1.12
inherit perl-module

DESCRIPTION="Subclass of LWP::UserAgent that protects you from harm"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/libwww-perl
	dev-perl/Net-DNS
	virtual/perl-Time-HiRes
"
RDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	local my_test_control
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	if has network ${my_test_control}; then
		einfo "Enabling ONLINE_TESTS"
		export ONLINE_TESTS=1
	else
		ewarn "Comprehensive testing requires network access. For details see:"
		ewarn "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
	perl_rm_files t/40-slowserver.t t/50-stuckserver.t
	perl-module_src_test
}
