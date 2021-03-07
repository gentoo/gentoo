# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-module

DESCRIPTION="Convert a plain text file to HTML"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/txt2html"
SRC_URI="https://github.com/resurrecting-open-source-projects/txt2html/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	!dev-perl/TextToHTML
	dev-perl/YAML-Syck
	virtual/perl-Getopt-Long"

DEPEND="
	${RDEPEND}
	dev-perl/Module-Build"
