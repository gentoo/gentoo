# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.38
inherit perl-module

DESCRIPTION='Web Scraping Toolkit using HTML and CSS Selectors or XPath expressions'
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-perl/HTML-Parser
	>=dev-perl/HTML-Selector-XPath-0.30.0
	dev-perl/HTML-Tagset
	>=dev-perl/HTML-Tree-3.230.0
	>=dev-perl/HTML-TreeBuilder-XPath-0.80.0
	>=dev-perl/libwww-perl-5.827.0
	virtual/perl-Scalar-List-Utils
	dev-perl/UNIVERSAL-require
	dev-perl/URI
	dev-perl/XML-XPathEngine
	dev-perl/YAML
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
	>=dev-perl/Module-Build-Tiny-0.39.0
	test? ( dev-perl/Test-Requires )
"
