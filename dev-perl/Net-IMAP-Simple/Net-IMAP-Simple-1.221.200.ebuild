# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JETTERO
DIST_VERSION=1.2212
DIST_EXAMPLES=( "contrib/*" )
DIST_WIKI="tests"
inherit perl-module

DESCRIPTION="Perl extension for simple IMAP account handling"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	virtual/perl-IO
	dev-perl/Parse-RecDescent
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	perl_rm_files t/{critic,pod{,_coverage}}.t
	perl-module_src_test
}
