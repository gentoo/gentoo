# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

DESCRIPTION="Process information and statistics using the kernel /proc interface"
HOMEPAGE="http://www.ward.nu/computer/psinfo/"
SRC_URI="http://www.ward.nu/computer/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"

PATCHES=(
	"${FILESDIR}/${P}-asneeded.patch"
)

src_prepare() {
	default
	tc-export CC
}
