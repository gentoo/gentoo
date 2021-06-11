# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Minesweeper clone with hexagonal, rectangular and triangular grid"
HOMEPAGE="http://www.gedanken.org.uk/software/xbomb/"
SRC_URI="http://www.gedanken.org.uk/software/xbomb/download/${P}.tgz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="x11-libs/libXaw"
RDEPEND="
	${DEPEND}
	acct-group/gamestat
"

PATCHES=(
	"${FILESDIR}"/${P}-DESTDIR.patch
	"${FILESDIR}"/${P}-ldflags.patch
)

src_prepare() {
	default

	sed -i \
		-e '/strip/d' \
		-e '/^CC=/d' \
		-e "/^CFLAGS/ { s:=.*:=${CFLAGS}: }" \
		Makefile || die
	sed -i \
		-e "s:/var/tmp:/var/lib/${PN}:g" \
		hiscore.c || die
}

src_configure() {
	tc-export CC
}

src_install() {
	default

	dodir /var/lib/${PN}
	touch "${ED}"/var/lib/${PN}/${PN}{3,4,6}.hi || die "touch failed"
	fperms 660 /var/lib/${PN}/${PN}{3,4,6}.hi

	fowners root:gamestat /var/lib/${PN}
	fperms g+s /usr/bin/${PN}

	make_desktop_entry xbomb XBomb
}
