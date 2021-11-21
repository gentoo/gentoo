# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

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

multilib_src_configure() {
	# The debug configure logic is broken.
	ECONF_SOURCE=${S} \
	econf \
		$(usex debug '--enable-debug' '') \
		--disable-static
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die "Failed to remove .la files"
}
