# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Multicast DNS repeater"
HOMEPAGE="https://github.com/kennylevinsen/mdns-repeater"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm"

SRC_URI="https://github.com/kennylevinsen/mdns-repeater/archive/${PV}.tar.gz -> ${P}.tar.gz"

PATCHES=(
	"${FILESDIR}/${P}-system-compiler-options.patch"
)

src_compile() {
	emake HGVERSION="${PV}" CC=$(tc-getCC)
}

src_install() {
	dobin "${PN}"
	dodoc README.txt
}
