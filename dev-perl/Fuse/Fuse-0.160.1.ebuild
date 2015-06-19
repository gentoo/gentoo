# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Fuse/Fuse-0.160.1.ebuild,v 1.2 2014/01/19 19:04:14 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DPATES
MODULE_VERSION=0.16.1
inherit perl-module

DESCRIPTION="Fuse module for perl"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

RDEPEND="sys-fs/fuse"
DEPEND="${RDEPEND}"

# Test is whack - ChrisWhite
#SRC_TEST="do"
