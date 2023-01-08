# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SocketCAN userspace utilities and tools"
HOMEPAGE="https://github.com/linux-can/can-utils"
SRC_URI="https://github.com/linux-can/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	eapply_user
}

src_compile() {
	emake || die "ERROR during compilation"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install || die "ERROR during install"
}
