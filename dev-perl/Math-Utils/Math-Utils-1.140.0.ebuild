# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JGAMBLE
DIST_VERSION=1.14
inherit perl-module

DESCRIPTION="Useful mathematical functions not in Perl"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
"

PERL_RM_FILES=( t/pod.t t/manifest.t )
