# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Fast cso compressor"
HOMEPAGE="https://github.com/unknownbrackets/maxcso"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/unknownbrackets/maxcso.git"
else
	SRC_URI="https://github.com/unknownbrackets/maxcso/archive/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC LGPL-2.1+ Apache-2.0"
SLOT="0"

DEPEND="
	app-arch/libdeflate
	app-arch/lz4:=
	dev-libs/libuv:=
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		USE_EXTERNAL_LIBDEFLATE=1
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		USE_EXTERNAL_LIBDEFLATE=1

	dodoc README.md README_CSO.md README_ZSO.md
}
