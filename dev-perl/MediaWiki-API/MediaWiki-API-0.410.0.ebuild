# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EXOBUZZ
DIST_VERSION=0.41
inherit perl-module

DESCRIPTION="A OO interface to the Mediawiki API"
LICENSE="GPL-3+"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="test"

RDEPEND="
	dev-perl/JSON
	dev-perl/libwww-perl
	virtual/perl-Carp
	virtual/perl-Encode
"
DEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.980.0
	)
"
src_test() {
	local my_test_control
	my_test_control=${DIST_TEST_OVERRIDE:-${DIST_TEST:-do parallel}}
	if has network ${my_test_control}; then
		perl_rm_files "t/98-pod-coverage.t" "t/99-pod.t"
	else
		perl_rm_files "t/98-pod-coverage.t" "t/99-pod.t" "t/10-api.t"
	fi
	perl-module_src_test
}
