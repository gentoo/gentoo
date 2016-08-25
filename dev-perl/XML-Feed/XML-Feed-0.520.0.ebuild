# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DAVECROSS
MODULE_VERSION=0.52
inherit perl-module

DESCRIPTION="Syndication feed parser and auto-discovery"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
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
	dev-perl/Module-Pluggable"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do

src_test() {
	perl_rm_files t/pod{,-coverage}.t
	perl-module_src_test
}
