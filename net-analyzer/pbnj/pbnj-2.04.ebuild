# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit perl-module

DESCRIPTION="A tool for running Nmap scans and diff'ing the results"
HOMEPAGE="http://pbnj.sourceforge.net/"
SRC_URI="mirror://sourceforge/pbnj/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-perl/DBD-SQLite
	dev-perl/DBI
	dev-perl/File-HomeDir
	dev-perl/File-Which
	dev-perl/Nmap-Parser
	dev-perl/Text-CSV_XS
	dev-perl/XML-Twig
	dev-perl/YAML
"
RDEPEND="
	${DEPEND}
	net-analyzer/nmap
"
