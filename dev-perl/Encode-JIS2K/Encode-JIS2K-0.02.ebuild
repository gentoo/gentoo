# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Encode-JIS2K/Encode-JIS2K-0.02.ebuild,v 1.1 2013/08/04 01:20:31 mrueg Exp $

EAPI=5

MODULE_AUTHOR="DANKOGAI"

inherit perl-module

DESCRIPTION="JIS X 0212 (aka JIS 2000) Encodings"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/perl-Encode"
DEPEND="${RDEPEND}"

SRC_TEST="do"
