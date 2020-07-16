# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Resize FAT partitions using libparted"
HOMEPAGE="https://github.com/ya-mouse/fatresize"
SRC_URI="https://github.com/ya-mouse/fatresize/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-block/parted
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${P}-version.patch
)

src_prepare() {
	default
	eautoreconf
}
