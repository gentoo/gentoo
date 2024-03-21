# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Rednex Game Boy Development System"
HOMEPAGE="https://rgbds.gbdev.io/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gbdev/${PN}.git"
else
	SRC_URI="https://github.com/gbdev/${PN}/archive/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DEPEND="media-libs/libpng"
RDEPEND="${DEPEND}"
BDEPEND="app-alternatives/yacc[bison]
	virtual/pkgconfig"

src_compile() {
	append-flags -DNDEBUG

	emake Q= \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_test() {
	local dir
	for dir in asm link fix gfx; do
		pushd "test/${dir}" >/dev/null || die
		./test.sh || die
		popd >/dev/null || die
	done
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr Q= STRIP= install
	dodoc README.md
}
