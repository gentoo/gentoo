# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Securely erase disks using a variety of recognized methods"
HOMEPAGE="https://github.com/martijnvanbrummelen/nwipe/"
SRC_URI="https://github.com/martijnvanbrummelen/nwipe/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libconfig:=
	sys-block/parted
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
