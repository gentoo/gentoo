# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MSTROUT
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Automatically set and update fields"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/DBIx-Class-0.81.270
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/DBICx-TestDatabase
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-0.04-no-dot-inc.patch"
)
