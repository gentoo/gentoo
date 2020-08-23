# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ADAMK
DIST_VERSION=1.51
inherit perl-module

DESCRIPTION="Static calls apply to a default instantiation"

SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ia64 ~mips ~ppc sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		>=virtual/perl-Test-Simple-0.470.0
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-1.51-no-dot-inc.patch"
)
PERL_RM_FILES=(
	t/98_pod.t
	t/99_pmv.t
)
