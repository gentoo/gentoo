# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIYAGAWA
DIST_VERSION=0.43
inherit perl-module

DESCRIPTION="Atom feed and API implementation"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-perl/Class-Data-Inheritable
	dev-perl/DateTime
	dev-perl/DateTime-TimeZone
	dev-perl/libwww-perl
	virtual/perl-MIME-Base64
	dev-perl/LWP-Authen-Wsse
	dev-perl/URI
	>=dev-perl/XML-LibXML-2.20.200
	>=dev-perl/XML-XPath-1.200.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	>=virtual/perl-ExtUtils-MakeMaker-6.590.0
"

PERL_RM_FILES=(
	"t/author-pod-syntax.t"
)
