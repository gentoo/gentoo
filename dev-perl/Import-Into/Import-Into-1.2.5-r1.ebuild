# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=HAARG
DIST_VERSION=1.002005
inherit perl-module

DESCRIPTION="Import packages into other packages"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86 ~x64-macos"

RDEPEND="
	dev-perl/Module-Runtime
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Exporter
		virtual/perl-Test-Simple
	)
"
