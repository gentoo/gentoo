# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Identify/delete duplicate files residing within specified directories"
HOMEPAGE="https://github.com/adrianlopezroche/fdupes"
if [[ "${PV}" == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/adrianlopezroche/fdupes.git"
else
	SRC_URI="https://github.com/adrianlopezroche/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
fi
LICENSE="MIT"
SLOT="0"
IUSE="+ncurses"

RDEPEND="
	dev-libs/libpcre2[pcre32]
	ncurses? ( sys-libs/ncurses:0= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( CHANGES CONTRIBUTORS README )

src_prepare() {
	default
	[[ "${PV}" == *9999 ]] && eautoreconf
}

src_configure() {
	econf $(use_with ncurses)
}

src_compile() {
	emake CC=$(tc-getCC)
}
