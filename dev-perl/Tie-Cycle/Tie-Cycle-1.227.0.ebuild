# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BDFOY
DIST_VERSION=1.227
inherit perl-module

DESCRIPTION="Cycle through a list of values via a scalar"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

RDEPEND="
	virtual/perl-Carp
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? (
		>=virtual/perl-Test-Simple-0.950.0
	)
"

PATCHES=( "${FILESDIR}/${PN}-1.225-nopodtests.patch" )

PERL_RM_FILES=( "t/pod.t" "t/pod_coverage.t" )
