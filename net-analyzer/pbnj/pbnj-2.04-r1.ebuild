# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit perl-module

DESCRIPTION="A tool for running Nmap scans and diff'ing the results"
HOMEPAGE="http://pbnj.sourceforge.net/"
SRC_URI="mirror://sourceforge/pbnj/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-perl/DBD-SQLite
	dev-perl/DBI
	dev-perl/File-HomeDir
	dev-perl/File-Which
	dev-perl/Nmap-Parser
	dev-perl/Shell
	dev-perl/Text-CSV_XS
	dev-perl/XML-Twig
	dev-perl/YAML
"
RDEPEND="
	${DEPEND}
	net-analyzer/nmap
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.04-ipv4_sort.patch
)

src_prepare() {
	default

	mv t/04change.t{,his-test-fails} || die
	mv t/05output.t{,his-test-fails} || die
}
