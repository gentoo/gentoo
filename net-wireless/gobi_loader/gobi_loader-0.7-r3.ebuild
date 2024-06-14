# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs udev

DESCRIPTION="gobi_loader is a firmware loader for Qualcomm Gobi USB chipsets"
HOMEPAGE="https://www.codon.org.uk/~mjg59/gobi_loader/"
SRC_URI="https://www.codon.org.uk/~mjg59/${PN}/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/libusb:0"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_prepare() {
	default
	sed -e "s:%UDEVDIR%:$(get_udevdir):" \
		-e "s:gcc:$(tc-getCC):" \
		-e "s:-Wall:& -Wno-unused-result:" \
		-i Makefile || die
}

src_install() {
	local -x prefix=${EPREFIX}
	emake install
	keepdir /lib/firmware/gobi
}

pkg_postinst() {
	udev_reload
	einfo "Put your firmware in /lib/firmware/gobi"
}

pkg_postrm() {
	udev_reload
}
