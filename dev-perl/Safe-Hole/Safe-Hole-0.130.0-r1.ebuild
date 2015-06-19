# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Safe-Hole/Safe-Hole-0.130.0-r1.ebuild,v 1.2 2015/06/13 22:41:51 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=TODDR
MODULE_VERSION=0.13
inherit perl-module

DESCRIPTION="Exec subs in the original package from Safe"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST="do"
