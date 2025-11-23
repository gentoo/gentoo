# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BRICAS
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Search and Retrieval by URL"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/CQL-Parser-1.120.0
	virtual/perl-Carp
	dev-perl/Class-Accessor
	dev-perl/URI
	dev-perl/XML-LibXML
	dev-perl/XML-Simple
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/CGI
		dev-perl/Test-Exception
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)
"
