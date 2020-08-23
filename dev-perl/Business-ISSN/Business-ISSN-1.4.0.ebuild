# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BDFOY
DIST_VERSION=1.004
inherit perl-module

DESCRIPTION="Object and functions to work with International Standard Serial Numbers"
LICENSE="Artistic-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
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
