# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ANDYA
DIST_VERSION=1.04
inherit perl-module

DESCRIPTION="Recursive decent XML parsing"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-perl/XML-TokeParser
"
BDEPEND="${RDEPEND}
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
