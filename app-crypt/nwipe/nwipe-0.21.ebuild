# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Securely erase disks using a variety of recognized methods"
HOMEPAGE="https://github.com/martijnvanbrummelen/nwipe/"
SRC_URI="https://github.com/martijnvanbrummelen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-block/parted-2.3
	>=sys-libs/ncurses-5.7-r7:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}
