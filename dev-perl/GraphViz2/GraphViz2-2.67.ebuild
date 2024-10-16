# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=2.67
inherit perl-module

DESCRIPTION="A wrapper for AT&T's GraphViz"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-gfx/graphviz
	dev-perl/Data-Section-Simple
	dev-perl/File-Which
	dev-perl/IPC-Run3
	dev-perl/Moo
	dev-perl/Type-Tiny
	dev-perl/Graph
"
BDEPEND="
	${RDEPEND}
	dev-perl/Test-Pod
	dev-perl/Pod-Markdown
	test? (
		dev-perl/Test-Snapshot
		>=virtual/perl-Test-Simple-1.1.2
	)
"
