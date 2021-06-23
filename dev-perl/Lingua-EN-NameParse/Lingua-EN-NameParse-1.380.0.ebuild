# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KIMRYAN
DIST_VERSION=1.38
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Routines for manipulating a person's name"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/Parse-RecDescent-1
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.380.0
	test? (
		>=virtual/perl-Test-Simple-0.940.0
	)
"

PERL_RM_FILES=( t/pod.t t/pod-coverage.t )
