# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib udev

DESCRIPTION="gobi_loader is a firmware loader for Qualcomm Gobi USB chipsets"
HOMEPAGE="https://www.codon.org.uk/~mjg59/gobi_loader/"
SRC_URI="https://www.codon.org.uk/~mjg59/${PN}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libusb:0"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_prepare() {
	default
	sed "s:%UDEVDIR%:$(get_udevdir):" -i Makefile || die
}

src_install() {
	emake install
}

pkg_postinst() {
	udevadm control --reload-rules
	einfo
	einfo "Put your firmware in /lib/firmware/gobi."
	einfo
}
