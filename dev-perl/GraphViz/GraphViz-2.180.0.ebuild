# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GraphViz/GraphViz-2.180.0.ebuild,v 1.1 2015/06/21 20:31:08 dilfridge Exp $

EAPI=5

MODULE_A_EXT=tgz
MODULE_AUTHOR=RSAVAGE
MODULE_VERSION=2.18
inherit perl-module

DESCRIPTION="GraphViz - Interface to the GraphViz graphing tool"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	media-gfx/graphviz
	virtual/perl-Carp
	>=virtual/perl-Getopt-Long-2.340.0
	virtual/perl-IO
	>=dev-perl/IPC-Run-0.600.0
	>=dev-perl/libwww-perl-6
	>=dev-perl/Parse-RecDescent-1.965.1
	>=virtual/perl-Time-HiRes-1.510.0
	>=dev-perl/XML-Twig-3.380.0
	>=dev-perl/XML-XPath-1.130.0
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.421.100
	>=dev-perl/File-Which-1.90.0
	test? (
		>=dev-perl/Test-Pod-1.480.0
	)
"

# tests need
#		>=virtual/perl-Test-Simple-1.1.14
# therefore temporarily disable
# SRC_TEST="do"

src_install() {
	perl-module_src_install

	insinto /usr/share/doc/${PF}/examples
	doins "${S}"/examples/*
}
