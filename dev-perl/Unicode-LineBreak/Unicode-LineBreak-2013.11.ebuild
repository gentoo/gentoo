# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-LineBreak/Unicode-LineBreak-2013.11.ebuild,v 1.1 2013/11/21 11:51:24 mrueg Exp $

EAPI=5

MODULE_AUTHOR="NEZUMI"

inherit perl-module

DESCRIPTION=" UAX #14 Unicode Line Breaking Algorithm"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/MIME-Charset
	virtual/perl-Encode"
DEPEND="${RDEPEND}"

SRC_TEST="do"
