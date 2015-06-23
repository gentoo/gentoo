# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-LineBreak/Unicode-LineBreak-2015.60.0.ebuild,v 1.1 2015/06/23 09:55:46 mrueg Exp $

EAPI=5

MODULE_AUTHOR="NEZUMI"
MODULE_VERSION="2015.06"

inherit perl-module

DESCRIPTION="UAX #14 Unicode Line Breaking Algorithm"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/MIME-Charset
	virtual/perl-Encode"
DEPEND="${RDEPEND}"

SRC_TEST="do"
