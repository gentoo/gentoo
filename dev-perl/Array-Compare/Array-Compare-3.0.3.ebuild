# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DAVECROSS
DIST_VERSION=v3.0.3
inherit perl-module

DESCRIPTION="Perl extension for comparing arrays"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Moo
	dev-perl/Type-Tiny
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="
	>=dev-perl/Module-Build-0.420.0
	test? ( ${RDEPEND}
		dev-perl/Test-NoWarnings
	)
"
PERL_RM_FILES=("t/pod.t" "t/pod_coverage.t")
