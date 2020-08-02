# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ADAMK
DIST_VERSION=1.02
inherit perl-module

DESCRIPTION="Calculate windows/subsets/pages of arrays"

SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/Params-Util-0.120.0
"
BDEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.02-no-dot-inc.patch"
)
PERL_RM_FILES=(
	"t/97_meta.t"
	"t/98_pod.t"
	"t/99_pmv.t"
)
