# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BAKERSCOT
DIST_VERSION=1.31
inherit perl-module

DESCRIPTION="String processing utility functions"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-perl/Module-Build-Tiny"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		>=virtual/perl-Test-Simple-0.880.0
	)
"
PERL_RM_FILES=(
	t/author-pod-syntax.t
)
