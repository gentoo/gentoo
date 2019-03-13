# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ANDYA
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Recursive decent XML parsing"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-perl/XML-TokeParser
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Differences
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/pod{,-coverage}.t
	perl-module_src_test
}
