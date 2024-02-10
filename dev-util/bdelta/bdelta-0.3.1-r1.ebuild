# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs vcs-snapshot

DESCRIPTION="Binary Delta - Efficient difference algorithm and format"
HOMEPAGE="https://github.com/jjwhitney/BDelta"
SRC_URI="https://github.com/jjwhitney/BDelta/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86 ~x86-linux"

PATCHES=(
	"${FILESDIR}"/${P}-soname.patch
	"${FILESDIR}"/${P}-gcc-6.patch
)

src_compile() {
	emake -C src \
		CXX="$(tc-getCXX)" \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	emake -C src install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	dodoc README
}
