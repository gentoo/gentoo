# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MBRADSHAW
DIST_VERSION=1.20171031
inherit perl-module

DESCRIPTION="Mock a DNS Resolver object for testing"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86"
IUSE="test"

RDEPEND="dev-perl/Net-DNS"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/author-*.t
	perl-module_src_test
}
