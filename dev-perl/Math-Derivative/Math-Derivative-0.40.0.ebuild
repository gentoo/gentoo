# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JGAMBLE
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="1st and 2nd order differentiation of data"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
PERL_RM_FILES=(
	"t/manifest.t"
	"t/pod.t"
)
RDEPEND=""
DEPEND="dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"
