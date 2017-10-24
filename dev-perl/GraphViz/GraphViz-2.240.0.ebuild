# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_A_EXT=tgz
DIST_AUTHOR=RSAVAGE
DIST_VERSION=2.24
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Interface to AT&T's GraphViz"

SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"

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
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/File-Which
	test? (
		>=virtual/perl-Test-Simple-1.1.2
	)
"
