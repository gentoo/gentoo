# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Command line tool for downloading Youtube closed captions"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://debian/pool/main/g/${PN}/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/Getopt-ArgvFile
		dev-perl/XML-DOM
		virtual/perl-Getopt-Long"
DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
