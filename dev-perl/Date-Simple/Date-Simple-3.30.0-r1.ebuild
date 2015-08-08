# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=IZUT
MODULE_VERSION=3.03
inherit perl-module

DESCRIPTION="A simple date object"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 GPL-3 )" # Artistic or GPL2+
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE=""

SRC_TEST=do
