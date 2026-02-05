# Copyright 1998-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

DESCRIPTION="A terminal emulator for GNUstep"
HOMEPAGE="http://www.nongnu.org/gap/terminal/"
SRC_URI="https://savannah.nongnu.org/download/gap/${P/t/T}.tar.gz"
S=${WORKDIR}/${P/t/T}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-termio.patch
	)
