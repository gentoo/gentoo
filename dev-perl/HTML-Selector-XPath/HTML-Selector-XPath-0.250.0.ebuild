# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CORION
DIST_VERSION=0.25
inherit perl-module

DESCRIPTION="CSS Selector to XPath compiler"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Encode
		dev-perl/Test-Base
	)
"
