# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PLOCALES="en ja"

inherit flag-o-matic l10n toolchain-funcs

DESCRIPTION="Yash is a POSIX-compliant command line shell"
HOMEPAGE="https://yash.osnd.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/69353/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls test"

RDEPEND="sys-libs/ncurses:=
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	test? ( sys-apps/ed )"

src_configure() {
	append-cflags -std=c99

	sh ./configure \
		--prefix="${EPREFIX}"/usr \
		$(use_enable nls) \
		CC=$(tc-getCC) \
		LINGUAS="$(l10n_get_locales | sed "s/en/en@quot en@boldquot/")" \
		|| die
}
