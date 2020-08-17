# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=EDAVIS
MODULE_VERSION=1.4
inherit perl-module

DESCRIPTION="Logging/debugging aid"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-perl/HTML-FromText-1.004"
DEPEND="${RDEPEND}"
PATCHES=("${FILESDIR}/${P}-posix-tmpnam.patch")
SRC_TEST="do"
