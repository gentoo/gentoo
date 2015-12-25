# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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

# Tests trigger stack overflow in sandbox code, see bug 553918
SRC_TEST=skip
