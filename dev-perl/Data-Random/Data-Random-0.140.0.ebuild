# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BAREFOOT
DIST_VERSION=0.14
DIST_WIKI="features tests"
inherit perl-module

DESCRIPTION="Module used to generate random data"

SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	>=dev-perl/File-ShareDir-Install-0.60.0
	test? (
		dev-perl/Test-MockTime
	)
"

PERL_RM_FILES=(
	"t/author-pod-syntax.t"
	"t/z0_pod.t"
	"t/z1_pod-coverage.t"
)
