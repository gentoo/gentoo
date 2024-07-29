# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BRIANDFOY
DIST_VERSION=1.006
inherit perl-module

DESCRIPTION="Object and functions to work with International Standard Serial Numbers"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	virtual/perl-Exporter
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? (
		>=virtual/perl-Test-Simple-1.0.0
	)
"

PERL_RM_FILES=(
	"t/pod.t"
	"t/pod_coverage.t"
	"t/test_manifest"
)

PATCHES=(
	"${FILESDIR}/${PN}-1.003-no-test-manifest.patch"
)
