# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

DESCRIPTION="Asynchronous networking library for GNUstep"
HOMEPAGE="https://gap.nongnu.org/talksoup/"
SRC_URI="https://savannah.nongnu.org/download/gap/${P}.tar.gz"

KEYWORDS="amd64 ppc x86"
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"

PATCHES=( "${FILESDIR}"/${P}-no_rfc.patch )
