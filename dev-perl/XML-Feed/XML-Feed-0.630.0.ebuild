# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAVECROSS
DIST_VERSION=0.63
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Syndication feed parser and auto-discovery"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="minimal"

RDEPEND="
	!minimal? (
		dev-perl/XML-RSS-LibXML
	)
	dev-perl/Class-ErrorHandler
	dev-perl/DateTime
	dev-perl/DateTime-Format-Flexible
	dev-perl/DateTime-Format-ISO8601
	dev-perl/DateTime-Format-Mail
	dev-perl/DateTime-Format-Natural
	dev-perl/DateTime-Format-W3CDTF
	dev-perl/Feed-Find
	dev-perl/HTML-Parser
	dev-perl/libwww-perl
	virtual/perl-Scalar-List-Utils
	dev-perl/Module-Pluggable
	dev-perl/URI-Fetch
	>=dev-perl/XML-Atom-0.380.0
	>=dev-perl/XML-LibXML-1.660.0
	>=dev-perl/XML-RSS-1.470.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? (
		virtual/perl-Test-Simple
	)
"

PERL_RM_FILES=("t/pod.t" "t/pod-coverage.t")
