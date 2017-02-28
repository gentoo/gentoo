# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_SECTION=lwp
DIST_AUTHOR=SAXJAZMAN
DIST_VERSION=1.10
inherit perl-module

DESCRIPTION="Subclass of LWP::UserAgent that protects you from harm"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

# Net::SSL 2.85 -> Crypt-SSLeay 0.58
DEPEND="dev-perl/libwww-perl
	dev-perl/Net-DNS
	virtual/perl-Time-HiRes
	>=dev-perl/Crypt-SSLeay-0.580.0
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
	fi
	perl-module_src_test
}
