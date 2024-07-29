# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnustep-2

S=${WORKDIR}/${P/z/Z}

DESCRIPTION="Zipper is a tool for inspecting and extracting compressed archives"
HOMEPAGE="https://gap.nongnu.org/zipper"
SRC_URI="https://savannah.nongnu.org/download/gap/${P/z/Z}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
