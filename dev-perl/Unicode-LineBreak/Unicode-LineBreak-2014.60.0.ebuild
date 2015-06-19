# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-LineBreak/Unicode-LineBreak-2014.60.0.ebuild,v 1.1 2014/07/01 00:06:07 mrueg Exp $

EAPI=5

MODULE_AUTHOR="NEZUMI"
MODULE_VERSION="2014.06"

inherit perl-module

DESCRIPTION="UAX #14 Unicode Line Breaking Algorithm"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/MIME-Charset
	virtual/perl-Encode"
DEPEND="${RDEPEND}"

SRC_TEST="do"
