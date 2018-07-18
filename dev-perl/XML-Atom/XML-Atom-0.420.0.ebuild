# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.42
inherit perl-module

DESCRIPTION="Atom feed and API implementation"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/Class-Data-Inheritable
	>=dev-perl/XML-LibXML-1.690.0
	dev-perl/XML-XPath
	dev-perl/DateTime
	dev-perl/DateTime-TimeZone
	dev-perl/Digest-SHA1
	dev-perl/HTML-Parser
	dev-perl/LWP-Authen-Wsse
	virtual/perl-MIME-Base64
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
"
PERL_RM_FILES=(
	"t/author-pod-syntax.t"
)
PATCHES=(
	"${FILESDIR}/${PN}-0.42-dotinc.patch"
	"${FILESDIR}/${PN}-0.42-testxxe.patch"
)
