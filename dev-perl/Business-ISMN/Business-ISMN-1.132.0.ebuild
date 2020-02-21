# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=1.132
inherit perl-module

DESCRIPTION="International Standard Music Numbers"
LICENSE="Artistic-2"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Tie-Cycle-1.210.0
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? ( >=virtual/perl-Test-Simple-0.950.0 )
"
PERL_RM_FILES=(
	t/pod.t
	t/pod_coverage.t
	t/test_manifest
)
PATCHES=(
	"${FILESDIR}/${PN}-1.132-no-test-manifest.patch"
)
