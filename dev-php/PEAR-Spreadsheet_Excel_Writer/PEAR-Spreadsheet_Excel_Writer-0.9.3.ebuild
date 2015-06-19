# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Spreadsheet_Excel_Writer/PEAR-Spreadsheet_Excel_Writer-0.9.3.ebuild,v 1.4 2015/05/08 08:30:27 ago Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Package for generating Excel spreadsheets"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
RDEPEND="dev-lang/php[iconv]
	>=dev-php/PEAR-OLE-0.5-r1"
IUSE=""
