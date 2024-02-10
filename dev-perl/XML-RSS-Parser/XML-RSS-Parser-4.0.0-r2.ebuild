# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMA
DIST_VERSION=4.0
inherit perl-module

DESCRIPTION="A liberal object-oriented parser for RSS feeds"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~ia64 sparc x86"

RDEPEND="
	dev-perl/Class-ErrorHandler
	>=dev-perl/Class-XPath-1.400.0
	>=dev-perl/XML-Elemental-2.0.0
"
BDEPEND="${RDEPEND}
"

src_unpack() {
	default
	mv -v "${WORKDIR}/${PN}-${DIST_VERSION/.0}" "${S}"
}
