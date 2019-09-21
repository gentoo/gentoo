# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=CHAMAS
DIST_VERSION=0.21
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="In memory size limited LRU cache"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

PATCHES=("${FILESDIR}/${PN}-0.21-benchmark.patch")
