# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GraphViz/GraphViz-2.40.0-r1.ebuild,v 1.1 2014/08/25 02:01:33 axs Exp $

EAPI=5

MODULE_AUTHOR=LBROCARD
MODULE_VERSION=2.04
inherit perl-module

DESCRIPTION="GraphViz - Interface to the GraphViz graphing tool"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="media-gfx/graphviz
	dev-perl/IPC-Run"
	#dev-perl/XML-Twig #used in GraphViz::XML
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"

src_install() {
	perl-module_src_install

	insinto /usr/share/doc/${PF}/examples
	doins "${S}"/examples/* || die
}
