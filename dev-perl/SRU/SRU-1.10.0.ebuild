# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BRICAS
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="Search and Retrieval by URL"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/CQL-Parser-1.120.0
	virtual/perl-Carp
	dev-perl/Class-Accessor
	dev-perl/URI
	dev-perl/XML-LibXML
	dev-perl/XML-Simple
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Exception
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"

SRC_TEST="do parallel"
