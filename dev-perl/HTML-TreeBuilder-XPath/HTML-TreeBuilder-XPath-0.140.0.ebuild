# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIROD
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="add XPath support to HTML::TreeBuilder"

SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-perl/HTML-Tree
	virtual/perl-Scalar-List-Utils
	>=dev-perl/XML-XPathEngine-0.120.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
