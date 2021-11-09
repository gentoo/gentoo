# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ASB
DIST_VERSION=0.16
inherit perl-module

DESCRIPTION="Perl extension for reading MS Excel 2007 files"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-perl/Archive-Zip-1.180.0
	dev-perl/Spreadsheet-ParseExcel
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( dev-perl/Test-NoWarnings )
"
