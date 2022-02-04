# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIROD
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Perl extension to add XPath support to XML::DOM, using XML::XPath engine"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/XML-DOM
	dev-perl/XML-XPathEngine
"
BDEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=("t/pod.t" "t/pod_coverage.t")

PATCHES=("${FILESDIR}/${PN}-0.14-encoding.patch")
