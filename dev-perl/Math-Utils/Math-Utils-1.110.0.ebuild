# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JGAMBLE
DIST_VERSION=1.11
inherit perl-module

DESCRIPTION="Useful mathematical functions not in Perl"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/pod.t t/manifest.t
	perl-module_src_test
}
