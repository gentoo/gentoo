# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAVID
DIST_VERSION=v${PV}
inherit perl-module

DESCRIPTION="A clock source that only increments and never jumps"

SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="
	>=dev-perl/Module-Build-0.360.400
"

PATCHES=(
	"${FILESDIR}/${P}-implicit.patch"
)
