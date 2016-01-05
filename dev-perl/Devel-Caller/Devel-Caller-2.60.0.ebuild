# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RCLAMP
MODULE_VERSION=2.06
inherit perl-module

DESCRIPTION="Meatier versions of caller"

SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~ppc ~x86"
IUSE=""

DEPEND="dev-perl/PadWalker"
RDEPEND="${DEPEND}"

SRC_TEST=do
