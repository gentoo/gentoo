# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=LBROCARD
DIST_VERSION=2.03
inherit perl-module

DESCRIPTION="Interface to the Imlib2 image library"

SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=media-libs/imlib2-1"
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28
	test? (
		>=media-libs/imlib2-1[jpeg,png]
	)
"

PERL_RM_FILES=( t/pod.t t/pod_coverage.t )
