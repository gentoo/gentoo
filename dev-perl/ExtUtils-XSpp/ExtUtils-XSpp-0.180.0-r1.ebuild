# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=SMUELLER
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="XS for C++"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/perl-Digest-MD5-2.0.0
	>=virtual/perl-ExtUtils-ParseXS-3.70.0
"
DEPEND="dev-perl/Module-Build"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	test? (
		dev-perl/Test-Differences
		dev-perl/Test-Base
	)
"
PATCHES=(
	"${FILESDIR}/${P}-no-dot-inc.patch"
)
PERL_RM_FILES=(
	"t/zzz_pod.t"
)
