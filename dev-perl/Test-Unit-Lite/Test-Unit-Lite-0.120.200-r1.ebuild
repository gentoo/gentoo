# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DEXTER
MODULE_VERSION=0.1202
inherit perl-module

DESCRIPTION="Unit testing without external dependencies"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-perl/Module-Build"

SRC_TEST=do
