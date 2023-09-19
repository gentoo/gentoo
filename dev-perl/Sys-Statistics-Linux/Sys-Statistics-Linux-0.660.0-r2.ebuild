# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BLOONIX
DIST_VERSION=0.66
DIST_EXAMPLES=( 'examples/*' )
inherit perl-module

DESCRIPTION="Collect linux system statistics"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/YAML-Syck
"
BDEPEND="
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"

src_test() {
	perl_rm_files t/001-pod.t t/002-pod-coverage.t
	perl-module_src_test
}
