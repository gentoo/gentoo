# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PLOCALES="en ja"

inherit flag-o-matic plocale toolchain-funcs

DESCRIPTION="Yash is a POSIX-compliant command line shell"
HOMEPAGE="https://magicant.github.io/yash/"
SRC_URI="https://github.com/magicant/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="nls test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/ncurses:=
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )
	test? ( sys-apps/ed )"

src_configure() {
	append-cflags -std=c99

	sh ./configure \
		--prefix="${EPREFIX}"/usr \
		--exec-prefix="${EPREFIX}" \
		$(use_enable nls) \
		CC="$(tc-getCC)" \
		LINGUAS="$(plocale_get_locales | sed "s/en/en@quot en@boldquot/")" \
		|| die
}
