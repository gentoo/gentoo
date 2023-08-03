# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CORION
DIST_VERSION=0.26
inherit perl-module

DESCRIPTION="CSS Selector to XPath compiler"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ~ppc64 ~riscv x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Encode
		dev-perl/HTML-TreeBuilder-XPath
		dev-perl/Test-Base
	)
"
