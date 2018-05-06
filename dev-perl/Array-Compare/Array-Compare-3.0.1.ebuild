# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAVECROSS
DIST_VERSION=v3.0.1
inherit perl-module

DESCRIPTION="Perl extension for comparing arrays"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Moo
	dev-perl/Type-Tiny
"
DEPEND="
	>=dev-perl/Module-Build-0.420.0
	test? ( ${RDEPEND}
		dev-perl/Test-NoWarnings
	)
"
PERL_RM_FILES=("t/pod.t" "t/pod_coverage.t")
