# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAVECROSS
DIST_VERSION=0.53
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Syndication feed parser and auto-discovery"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="test minimal"

RDEPEND="
	!minimal? (
		dev-perl/XML-RSS-LibXML
	)
	dev-perl/Class-ErrorHandler
	dev-perl/Feed-Find
	dev-perl/URI-Fetch
	>=dev-perl/XML-RSS-1.470.0
	>=dev-perl/XML-Atom-0.380.0
	dev-perl/DateTime
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-W3CDTF
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/Module-Pluggable
	virtual/perl-Scalar-List-Utils
	!<dev-perl/XML-LibXML-1.660.0
"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=("t/pod.t" "t/pod-coverage.t")
PATCHES=("${FILESDIR}/${PN}-0.53-dotinc.patch")
