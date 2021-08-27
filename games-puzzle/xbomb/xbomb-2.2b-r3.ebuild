# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Minesweeper clone with hexagonal, rectangular and triangular grid"
HOMEPAGE="http://www.gedanken.org.uk/software/xbomb/"
SRC_URI="http://www.gedanken.org.uk/software/xbomb/download/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="
	acct-group/gamestat
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt
"
RDEPEND="
	${DEPEND}
	media-fonts/font-misc-misc
"

PATCHES=(
	"${FILESDIR}"/${P}-DESTDIR.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default

	sed -i -e '/strip/d' Makefile || die
	sed -i \
		-e "s:/var/tmp:${EPREFIX}/var/games/${PN}:g" \
		hiscore.c || die
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${ED}" install
	einstalldocs

	dodir /var/games/${PN}
	touch "${ED}"/var/games/${PN}/${PN}{3,4,6}.hi || die "touch failed"

	fowners :gamestat /var/games/${PN}{,/${PN}{3,4,6}.hi} /usr/bin/${PN}
	fperms 660 /var/games/${PN}/${PN}{3,4,6}.hi
	fperms g+s /usr/bin/${PN}

	make_desktop_entry xbomb XBomb
}
