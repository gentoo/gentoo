# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="security-aware parser for the HTTP protocol and the related bits and pieces"
HOMEPAGE="https://github.com/OISF/libhtp"
SRC_URI="https://github.com/OISF/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~riscv ~x86"
IUSE="debug"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# The debug configure logic is broken.
	econf $(usev debug '--enable-debug')
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die "Failed to remove .la files"
}
