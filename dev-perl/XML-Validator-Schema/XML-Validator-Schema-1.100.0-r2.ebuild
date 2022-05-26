# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SAMTREGAR
DIST_VERSION=1.10

inherit perl-module

DESCRIPTION="Validate XML against a subset of W3C XML Schema"

SLOT="0"
KEYWORDS="~amd64"

# >= on XML-Sax needed to avoid "miscompilation" (essentially empty install), as newer XML-Sax
# has the ROOT check fixed. Didn't happen with XML-SAX-Expat, but best to be careful.
# bug #840053
RDEPEND="
	>=dev-perl/XML-SAX-1.20.0-r1
	dev-perl/Tree-DAG_Node
	dev-perl/XML-Filter-BufferText
"
BDEPEND="${RDEPEND}
"
