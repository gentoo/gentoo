# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Simple maze-like game where you navigate around and destroy arrows"
HOMEPAGE="http://noreason.ca/?file=software"
SRC_URI="http://noreason.ca/data/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/pango"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Modify path to data
	sed -i \
		-e "s|arrfl|${EPREFIX}/usr/share/${PN}/arrfl|" \
		-e 's|nm\[9|nm[35|' \
		-e 's|nm\[6|nm[30|' \
		-e 's|nm\[7|nm[31|' \
		game.c || die
}

src_compile() {
	emake clean
	emake CC="$(tc-getCC)" CCOPTS="${CFLAGS}" LINKOPTS="${LDFLAGS}"
}

src_install() {
	dobin arrows

	insinto /usr/share/${PN}
	doins arrfl.[1-5]
	einstalldocs

	make_desktop_entry ${PN} ${PN^} applications-games
}
