# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALIAN
DIST_VERSION=1.24
inherit perl-module

DESCRIPTION="Provide routine to transform a HTML page in a MIME-Lite mail"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/MIME-Lite
	dev-perl/URI
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"

PATCHES=(
	"${FILESDIR}/${P}-tests1.patch"
	"${FILESDIR}/${P}-tests2.patch"
)

DIST_TEST=do
