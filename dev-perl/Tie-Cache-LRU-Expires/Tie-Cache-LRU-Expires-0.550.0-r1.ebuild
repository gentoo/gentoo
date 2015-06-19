# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-Cache-LRU-Expires/Tie-Cache-LRU-Expires-0.550.0-r1.ebuild,v 1.1 2014/08/26 17:58:13 axs Exp $

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
