# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_VERSION=${PV%0.0}
DIST_AUTHOR=BSCHMITZ
inherit perl-module

DESCRIPTION="Perl extension for looking up the whois information for ip addresses"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
# All tests defined require networking
#  and all fail.
# https://rt.cpan.org/Public/Bug/Display.html?id=110961
RESTRICT="test"
PERL_RM_FILES=(
	"test.pl" # gets installed otherwise :(
)
RDEPEND="
	dev-perl/Regexp-IPv6
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
src_test() {
	local my_test_control
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	if ! has network ${my_test_control} ; then
		perl_rm_files "t/test1.t" "t/testx.t"
	fi
	perl-module_src_test
}
