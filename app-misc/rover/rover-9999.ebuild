# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="simple file browser for the terminal"
HOMEPAGE="https://lecram.github.io/p/rover/"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lecram/${PN}.git"
else
	SRC_URI="https://github.com/lecram/${PN}/archive/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="public-domain"
SLOT="0"

DEPEND="sys-libs/ncurses:=[unicode(+)]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	emake CC="$(tc-getCC)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	dodoc README.md
}
