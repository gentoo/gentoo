# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BOXZOU
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Produce common sub-string indices for two strings"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"

SRC_URI+=" https://dev.gentoo.org/~dilfridge/distfiles/${P}-swig.patch.xz"

PATCHES=( "${WORKDIR}/${P}-swig.patch" )
