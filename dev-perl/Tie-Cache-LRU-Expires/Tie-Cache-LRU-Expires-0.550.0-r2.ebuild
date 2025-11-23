# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OESTERHOL
DIST_VERSION=0.55
inherit perl-module

DESCRIPTION="Extends Tie::Cache::LRU with expiring"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/Tie-Cache-LRU"
BDEPEND="${RDEPEND}
"
