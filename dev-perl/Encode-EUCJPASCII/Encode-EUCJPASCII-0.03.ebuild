# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Encode-EUCJPASCII/Encode-EUCJPASCII-0.03.ebuild,v 1.1 2013/08/04 01:11:35 mrueg Exp $

EAPI=5

MODULE_AUTHOR="NEZUMI"

inherit perl-module

DESCRIPTION="An eucJP-open mapping"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/perl-Encode"
DEPEND="${RDEPEND}"

SRC_TEST="do"
