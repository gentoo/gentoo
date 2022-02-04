# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SALVA
DIST_VERSION=0.03

inherit perl-module

DESCRIPTION="Sort IP v4 addresses"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-perl/Sort-Key-1.280.0
"
BDEPEND="${RDEPEND}
"

PERL_RM_FILES=( "t/pods.t" )
