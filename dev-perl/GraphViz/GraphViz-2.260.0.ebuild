# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=2.26
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Interface to AT&T's GraphViz"

SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv x86"

RDEPEND="
	media-gfx/graphviz
	>=virtual/perl-Carp-1.10.0
	>=virtual/perl-Getopt-Long-2.340.0
	virtual/perl-IO
	>=dev-perl/IPC-Run-0.600.0
	>=dev-perl/libwww-perl-6
	>=dev-perl/Parse-RecDescent-1.965.1
	>=virtual/perl-Time-HiRes-1.510.0
	>=dev-perl/XML-Twig-3.520.0
	>=dev-perl/XML-XPath-1.130.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/File-Which
	test? (
		>=virtual/perl-Test-Simple-1.1.2
	)
"
