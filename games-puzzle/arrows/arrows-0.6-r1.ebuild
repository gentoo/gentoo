# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Simple maze-like game where you navigate around and destroy arrows"
HOMEPAGE="http://noreason.ca/?file=software"
SRC_URI="http://noreason.ca/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default

	# Modify path to data
	sed -i \
		-e "s:arrfl:/usr/share/${PN}/arrfl:" \
		-e 's:nm\[9:nm[35:' \
		-e 's:nm\[6:nm[30:' \
		-e 's:nm\[7:nm[31:' \
		game.c \
		|| die 'sed failed'
	sed -i \
		-e '/^CC /d' \
		-e '/CCLIBS/s:$: $(LDFLAGS):' \
		Makefile \
		|| die 'sed failed'
}

src_compile() {
	make clean || die "make clean failed"
	emake CCOPTS="${CFLAGS}"
}

src_install() {
	dobin arrows
	insinto "/usr/share/${PN}"
	doins arrfl*
	einstalldocs
}
