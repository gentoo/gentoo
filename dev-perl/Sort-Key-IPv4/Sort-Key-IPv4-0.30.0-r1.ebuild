# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="SALVA"
DIST_VERSION="0.03"

inherit perl-module

DESCRIPTION="Sort IP v4 addresses"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-perl/Sort-Key-1.280.0"
DEPEND="${RDEPEND}"

PERL_RM_FILES=( "t/pods.t" )
