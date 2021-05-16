# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=OESTERHOL
MODULE_VERSION=0.55
inherit perl-module

DESCRIPTION="Extends Tie::Cache::LRU with expiring"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/Tie-Cache-LRU"
DEPEND="${RDEPEND}"

SRC_TEST=do
