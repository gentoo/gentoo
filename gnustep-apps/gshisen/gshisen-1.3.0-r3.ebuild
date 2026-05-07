# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2 edos2unix

MY_PN=GShisen
DESCRIPTION="The first GNUstep game, similar to Mahjongg"
HOMEPAGE="https://gap.nongnu.org/gshisen/index.html"
SRC_URI="https://savannah.nongnu.org/download/gap/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}/${P}-warnings.patch" )

src_prepare() {
	edos2unix board.m

	default
}
