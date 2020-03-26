# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="ncurses based hex editor"
HOMEPAGE="https://github.com/LonnyGomes/hexcurse"
SRC_URI="https://github.com/LonnyGomes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	>=sys-libs/ncurses-5.2:0=
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.60.0-Werror.patch
	"${FILESDIR}"/${PN}-1.60.0-tinfo.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc AUTHORS ChangeLog NEWS README
}
