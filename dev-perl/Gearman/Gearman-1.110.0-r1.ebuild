# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=1.11
inherit perl-module

DESCRIPTION="Gearman distributed job system"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-perl/string-crc32"
RDEPEND="${DEPEND}"

mydoc="CHANGES HACKING TODO"
# testsuite requires gearman server
SRC_TEST="never"
