# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=1.022
inherit perl-module

DESCRIPTION="Utilities for interactive I/O"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	>=virtual/perl-version-0.780.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? ( >=virtual/perl-Test-Simple-0.940.0 )
"
src_test() {
	perl_rm_files "t/pod.t" "t/pod-coverage.t"
	perl-module_src_test
}
