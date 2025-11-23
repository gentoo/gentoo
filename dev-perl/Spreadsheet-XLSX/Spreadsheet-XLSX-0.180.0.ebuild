# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ASB
DIST_VERSION=0.18
inherit perl-module

DESCRIPTION="Perl extension for reading MS Excel 2007 files"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-perl/Archive-Zip-1.180.0
	dev-perl/Spreadsheet-ParseExcel
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-NoWarnings
		dev-perl/Test-Warnings
	)
"
