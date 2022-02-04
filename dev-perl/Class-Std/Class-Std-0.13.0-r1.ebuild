# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHORNY
DIST_VERSION=0.013
DIST_EXAMPLES=("demo/*")
inherit perl-module

DESCRIPTION='Support for creating standard "inside-out" classes'

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Data-Dumper
	virtual/perl-Scalar-List-Utils
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
	)
"
