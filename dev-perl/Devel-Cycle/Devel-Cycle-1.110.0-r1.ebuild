# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Devel-Cycle/Devel-Cycle-1.110.0-r1.ebuild,v 1.3 2014/12/07 19:19:16 zlogene Exp $

EAPI=5

MODULE_AUTHOR=LDS
MODULE_VERSION=1.11
inherit perl-module

DESCRIPTION="Find memory cycles in objects"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

SRC_TEST="do"
