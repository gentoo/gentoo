# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=GWILLIAMS
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Parse and format W3CDTF datetime strings"

SLOT="0"
KEYWORDS="alpha amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/DateTime"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

SRC_TEST="do"
