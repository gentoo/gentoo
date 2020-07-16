# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JGAMBLE
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="1st and 2nd order differentiation of data"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND=""
DEPEND="dev-perl/Module-Build
	test? (
		>=dev-perl/Math-Utils-1.10.0
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/manifest.t t/pod.t
	perl-module_src_test
}
