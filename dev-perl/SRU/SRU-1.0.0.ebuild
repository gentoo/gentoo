# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/SRU/SRU-1.0.0.ebuild,v 1.1 2013/01/25 19:54:39 tove Exp $

EAPI=5

MODULE_AUTHOR=BRICAS
MODULE_VERSION=1.00
inherit perl-module

DESCRIPTION="Catalyst::Controller::SRU - Dispatch SRU methods with Catalyst"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/URI
	dev-perl/XML-LibXML
	dev-perl/XML-Simple
	dev-perl/Class-Accessor
	>=dev-perl/CQL-Parser-1.120.0
"
DEPEND="
	test? (
		${RDEPEND}
		dev-perl/Test-Exception
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST=do
