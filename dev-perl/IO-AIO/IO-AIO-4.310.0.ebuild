# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-AIO/IO-AIO-4.310.0.ebuild,v 1.3 2015/07/04 13:18:46 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=4.31
inherit perl-module

DESCRIPTION="Asynchronous Input/Output"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="dev-perl/common-sense"
RDEPEND="${DEPEND}"

SRC_TEST=skip
