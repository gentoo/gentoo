# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JETTERO
DIST_VERSION=1.2209
DIST_EXAMPLES=( "contrib/*" )
inherit perl-module

DESCRIPTION="Perl extension for simple IMAP account handling"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/perl-IO
	dev-perl/Parse-RecDescent
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

src_test() {
	if [[ -z ${NIS_TEST_HOST} ]]; then
		elog "Comprehensive testing requires some manual configuration, for details, see:"
		elog "https://wiki.gentoo.org/wiki/Project:Perl/maint-notes/${CATEGORY}/${PN}"
	fi
	perl_rm_files t/{critic,pod{,_coverage}}.t
	perl-module_src_test
}
