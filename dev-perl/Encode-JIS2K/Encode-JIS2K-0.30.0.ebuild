# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Encode-JIS2K/Encode-JIS2K-0.30.0.ebuild,v 1.1 2015/06/08 08:43:32 mrueg Exp $

EAPI=5

MODULE_AUTHOR="DANKOGAI"
MODULE_VERSION="0.03"

inherit perl-module

DESCRIPTION="JIS X 0212 (aka JIS 2000) Encodings"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/perl-Encode"
DEPEND="${RDEPEND}"

SRC_TEST="do"
