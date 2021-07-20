# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EDAVIS
DIST_VERSION=1.4
inherit perl-module

DESCRIPTION="Logging/debugging aid"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-perl/HTML-FromText-1.4.0
"
BDEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/${P}-posix-tmpnam.patch")
