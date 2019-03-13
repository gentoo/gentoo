# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PHOENIX
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Asking the user for a password"

SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""
PERL_RM_FILES=( "t/2_interactive.t" )
