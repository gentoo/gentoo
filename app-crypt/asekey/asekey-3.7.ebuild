# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

DESCRIPTION="ASEKey USB SIM Card Reader"
HOMEPAGE="https://www.athena-scs.com/"
SRC_URI="http://www.athena-scs.com/docs/reader-drivers/${PN}-${PV/./-}-tar.bz2 -> ${P}.tar.bz2"
LICENSE="BSD LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="sys-apps/pcsc-lite[udev]
	virtual/libusb:0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-bundle.patch"
)

src_prepare() {
	default
	sed -i -e 's/GROUP="pcscd"/ENV{PCSCD}="1"/' "92_pcscd_${PN}.rules" || die
}

src_configure() {
	econf --with-udev-rules-dir="$(get_udevdir)/rules.d"
}
