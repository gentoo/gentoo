# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Clone of a C64 game -  destroy the opponent's house"
HOMEPAGE="https://github.com/kouya/tornado"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-devel/gettext
"

RDEPEND="
	virtual/libintl
"

PATCHES=(
	"${FILESDIR}"/${PF}-gentoo.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	default
	fperms 664 "/var/games/tornado.scores"
}
