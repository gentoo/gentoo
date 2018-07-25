# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=KIMRYAN
DIST_VERSION=1.36
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="routines for manipulating a person's name"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Parse-RecDescent-1
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		>=virtual/perl-Test-Simple-0.940.0
	)
"
src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
