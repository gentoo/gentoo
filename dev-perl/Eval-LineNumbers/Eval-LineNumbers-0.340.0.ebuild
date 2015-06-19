# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Eval-LineNumbers/Eval-LineNumbers-0.340.0.ebuild,v 1.2 2014/07/29 21:34:59 zlogene Exp $

EAPI=5
MODULE_AUTHOR=MUIR
MODULE_SECTION=modules
MODULE_VERSION=0.34

inherit perl-module

DESCRIPTION="Add line numbers to hereis blocks that contain perl source code"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"
