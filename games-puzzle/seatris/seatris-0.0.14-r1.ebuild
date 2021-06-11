# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A color ncurses tetris clone"
HOMEPAGE="http://www.earth.li/projectpurple/progs/seatris.html"
SRC_URI="http://www.earth.li/projectpurple/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="sys-libs/ncurses:="
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:/var/lib/games:/var/lib/${PN}:" \
		scoring.h seatris.6 || die
}

src_configure() {
	tc-export CC
	econf
}

src_compile() {
	emake LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )"
}

src_install() {
	dobin seatris

	doman seatris.6
	dodoc ACKNOWLEDGEMENTS HISTORY README TODO example.seatrisrc

	dodir /var/lib/${PN}
	touch "${ED}"/var/lib/${PN}/seatris.score || die
	fperms 660 /var/lib/${PN}/seatris.score

	fowners -R root:gamestat /var/lib/${PN}
	fperms g+s /usr/bin/${PN}
}
