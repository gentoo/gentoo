# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=BDFOY
DIST_VERSION=1.003
inherit perl-module

DESCRIPTION="Object and functions to work with International Standard Serial Numbers"
LICENSE="Artistic-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"

RDEPEND="
	virtual/perl-Exporter
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.640.0
	virtual/perl-File-Spec
	test? ( virtual/perl-Test-Simple )
"
PERL_RM_FILES=(
	"t/pod.t"
	"t/pod_coverage.t"
	"t/test_manifest"
)
PATCHES=(
	"${FILESDIR}/${PN}-1.003-no-test-manifest.patch"
)
