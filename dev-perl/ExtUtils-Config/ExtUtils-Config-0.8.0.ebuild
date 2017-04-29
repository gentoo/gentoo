# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
EAPI=6
DIST_AUTHOR=LEONT
DIST_VERSION=0.008
inherit perl-module

DESCRIPTION="A wrapper for perl's configuration"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ~ppc64 ~sparc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Data-Dumper
"
DEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		>=virtual/perl-Test-Simple-0.88
	)
"
src_test() {
	perl_rm_files t/release-pod-{syntax,coverge}.t
	perl-module_src_test
}
