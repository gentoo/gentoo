# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DBRIAN
DIST_VERSION=0.53
inherit perl-module

DESCRIPTION="A Perl XML Simple package"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc x86"

RDEPEND="
	>=dev-perl/XML-Parser-2.300.0
	>=dev-perl/XML-LibXML-1.540.0
"
BDEPEND="${RDEPEND}
"

src_unpack() {
	default
	S=${WORKDIR}/${PN}${DIST_VERSION}
}
