# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="ncurses based hex editor"
HOMEPAGE="https://github.com/LonnyGomes/hexcurse"
SRC_URI="https://github.com/LonnyGomes/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND=">=sys-libs/ncurses-5.2:0="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-Werror.patch
	"${FILESDIR}"/${P}-tinfo.patch
	"${FILESDIR}"/${P}-gcc10.patch
)

src_prepare() {
	default
	rm README.Irix || die
	eautoreconf
}
