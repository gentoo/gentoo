# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SAMTREGAR
DIST_VERSION=1.10

inherit perl-module

DESCRIPTION="Validate XML against a subset of W3C XML Schema"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/XML-SAX
	dev-perl/Tree-DAG_Node
	dev-perl/XML-Filter-BufferText
"
BDEPEND="${RDEPEND}
"
