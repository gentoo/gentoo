# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.07
inherit perl-module

DESCRIPTION="Extract License and Copyright from its main_module file"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
RDEPEND="
	>=dev-perl/Dist-Zilla-4.300.30
	>=virtual/perl-Module-Load-0.320.0
	dev-perl/Software-License
"
DEPEND="
	dev-perl/Module-Build-Tiny
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		dev-perl/JSON
	)
"
PERL_RM_FILES=(
	"t/author-pod-syntax.t"
)
