# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit udev

DESCRIPTION="ASEKey USB SIM Card Reader"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="https://dev.gentoo.org/~sam/distfiles/app-crypt/asekey/${P}.tar.bz2"
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
