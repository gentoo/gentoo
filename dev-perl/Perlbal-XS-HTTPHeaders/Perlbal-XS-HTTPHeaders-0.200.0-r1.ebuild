# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DORMANDO
DIST_VERSION=0.20
inherit perl-module

DESCRIPTION="XS acceleration for Perlbal header processing"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="dev-perl/Perlbal"
BDEPEND="${RDEPEND}"
