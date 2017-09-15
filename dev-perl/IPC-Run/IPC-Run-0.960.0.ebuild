# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TODDR
DIST_VERSION=0.96
inherit perl-module

DESCRIPTION="system() and background procs w/ piping, redirs, ptys"

SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86 ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-perl/IO-Tty-1.80.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"

src_test() {
	perl_rm_files t/97_meta.t t/98_pod_coverage.t t/98_pod.t t/99_perl_minimum_version.t
	perl-module_src_test
}
