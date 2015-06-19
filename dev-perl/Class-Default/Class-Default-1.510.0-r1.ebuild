# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Default/Class-Default-1.510.0-r1.ebuild,v 1.2 2015/06/13 21:36:52 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=ADAMK
MODULE_VERSION=1.51
inherit perl-module

DESCRIPTION="Static calls apply to a default instantiation"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ~ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28"

SRC_TEST="do"
