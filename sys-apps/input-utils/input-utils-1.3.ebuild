# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="input"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Small collection of linux input layer utils"
HOMEPAGE="https://www.kraxel.org/blog/linux/input/"
SRC_URI="https://www.kraxel.org/releases/input/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~riscv x86"

src_install() {
	emake EPREFIX="${EPREFIX}/usr" bindir="${ED}"/usr/bin mandir="${ED}"/usr/share/man STRIP="" install
	dodoc lircd.conf
	dodoc README
}
