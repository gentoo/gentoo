# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=TIMB
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Client API for the NeuStar UltraDNS Transaction Protocol"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/Net-SSLeay-1.350.0
	dev-perl/Test-Exception
	>=dev-perl/RPC-XML-0.640.0
	dev-perl/XML-LibXML"
RDEPEND="${DEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
PATCHES=(
	"${FILESDIR}/${PN}-0.06-dotinc.patch"
	"${FILESDIR}/${PN}-0.06-nomkmethods.patch"
)
PERL_RM_FILES=("t/perlcritic.t" "t/perlcritic" "t/pod-coverage.t" "t/pod.t")
mydoc="NUS_API_XML.errata"
