# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TIMA
MODULE_VERSION=4.0
MY_S=${WORKDIR}/${PN}-${MODULE_VERSION/.0}
inherit perl-module

DESCRIPTION="A liberal object-oriented parser for RSS feeds"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ia64 sparc x86"
IUSE=""

RDEPEND="dev-perl/Class-ErrorHandler
	>=dev-perl/Class-XPath-1.4
	>=dev-perl/XML-Elemental-2.0"
DEPEND="${RDEPEND}"

SRC_TEST="do"
