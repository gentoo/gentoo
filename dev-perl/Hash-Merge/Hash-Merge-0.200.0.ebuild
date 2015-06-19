# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Hash-Merge/Hash-Merge-0.200.0.ebuild,v 1.2 2015/01/09 00:30:20 zlogene Exp $

EAPI=5

MODULE_AUTHOR=REHSACK
MODULE_VERSION=0.200
inherit perl-module

DESCRIPTION="Merges arbitrarily deep hashes into a single hash"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~ppc-aix ~ppc-macos ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/Clone"
DEPEND="${RDEPEND}"

SRC_TEST=do
