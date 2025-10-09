# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Fast dense matrix arithmetic over GF(2^e) for 2 <= e <= 16"
HOMEPAGE="https://github.com/malb/m4rie"
SRC_URI="https://github.com/malb/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug"

DEPEND=">sci-libs/m4ri-20240729-r0:="
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
