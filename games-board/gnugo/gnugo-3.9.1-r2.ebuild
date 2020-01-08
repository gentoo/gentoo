# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A Go-playing program"
HOMEPAGE="https://www.gnu.org/software/gnugo/devel.html"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="readline"

RDEPEND="
	readline? ( sys-libs/readline:0= )
	>=sys-libs/ncurses-5.2-r3:0=
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-invalid-move.patch
	"${FILESDIR}"/${P}-format-security.patch
)

src_configure() {
	econf \
		$(use_with readline) \
		--enable-cache-size=32
}
