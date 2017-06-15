# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=AMBS
DIST_VERSION=0.08

inherit perl-module

DESCRIPTION="A tool to build C libraries"

SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-ExtUtils-CBuilder-0.230.0
	virtual/perl-File-Spec
	virtual/perl-File-Temp
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
	)
"
src_test() {
	perl_rm_files t/pod.t t/pod-coverage.t
	perl-module_src_test
}
