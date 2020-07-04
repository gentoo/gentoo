# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=XAERXESS
DIST_VERSION=1.004
inherit perl-module

DESCRIPTION="Implements an ordered hash-like object"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-Carp"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
src_test() {
	perl_rm_files t/10_changes.t t/11_kwalitee.t
	perl-module_src_test
}
