# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAVECROSS
inherit perl-module

DESCRIPTION="Perl extension for comparing arrays"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"

# Object-Pad is only for < 5.38, so we can clean it up later
RDEPEND="
	virtual/perl-Carp
	dev-perl/Feature-Compat-Class
	dev-perl/Moo
	dev-perl/Object-Pad
	dev-perl/Type-Tiny
"
DEPEND="
	dev-perl/Module-Build
"
BDEPEND="
	>=dev-perl/Module-Build-0.420.0
	test? (
		${RDEPEND}
		dev-perl/Test-NoWarnings
	)
"

PERL_RM_FILES=("t/pod.t" "t/pod_coverage.t")
