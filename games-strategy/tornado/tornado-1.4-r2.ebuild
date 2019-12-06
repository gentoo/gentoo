# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Clone of a C64 game -  destroy the opponent's house"
HOMEPAGE="https://github.com/kouya/tornado"
SRC_URI="https://github.com/kouya/tornado/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="
	nls? ( sys-devel/gettext )
"

RDEPEND="
	nls? ( virtual/libintl )
"

PATCHES=(
	"${FILESDIR}"/${PF}-gentoo.patch
)

src_configure() {
	if ! use nls; then
		sed -i \
			-e '/^all:/s|locales||g' \
			-e '/^install:/s|install-locale-data||g' \
			Makefile || die
	fi

	tc-export CC PKG_CONFIG
}

src_install() {
	default
	fperms 664 "/var/games/tornado.scores"
}
