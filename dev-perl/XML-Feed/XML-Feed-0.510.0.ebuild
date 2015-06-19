# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Feed/XML-Feed-0.510.0.ebuild,v 1.3 2015/06/13 22:26:24 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=DAVECROSS
MODULE_VERSION=0.51
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
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
