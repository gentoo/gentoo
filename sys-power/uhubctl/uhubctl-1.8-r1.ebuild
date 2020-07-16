# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="USB hub per-port power control"
HOMEPAGE="https://github.com/mvp/uhubctl"
SRC_URI="https://github.com/mvp/uhubctl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND="virtual/libusb:1"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i "s#\$(shell git describe --abbrev=4 --dirty --always --tags)#${PV}#" Makefile || die
	eapply_user
}
