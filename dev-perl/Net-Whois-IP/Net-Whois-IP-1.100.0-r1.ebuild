# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_VERSION=${PV%0.0}
MODULE_AUTHOR=BSCHMITZ
inherit perl-module

DESCRIPTION="Perl extension for looking up the whois information for ip addresses"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND=""

SRC_TEST="online"
