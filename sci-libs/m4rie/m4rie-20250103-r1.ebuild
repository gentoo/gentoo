# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Fast dense matrix arithmetic over GF(2^e) for 2 <= e <= 16"
HOMEPAGE="https://github.com/malb/m4rie"
SRC_URI="https://github.com/malb/${PN}/archive/refs/tags/release-${PV}.tar.gz"

S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~riscv ~x86 ~x64-macos"
IUSE="debug"

DEPEND=">=sci-libs/m4ri-20240729"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-pkgconfig-r1.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# m4rie doesn't actually have any openmp code. The configure flag
	# stems from a mistaken belief that it needs to be there to use the
	# openmp code in m4ri.
	econf \
		--disable-openmp \
		$(use_enable debug)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
