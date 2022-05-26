# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Displays a count and a graph of the traffic over a specified network connection"
HOMEPAGE="https://www.xs4all.nl/~rsmith/software/"
SRC_URI="https://www.xs4all.nl/~rsmith/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

DEPEND="
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libXaw
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.11.3-libdir.patch"
)

src_prepare() {
	sed -i \
		-e 's;CFLAGS = -pipe -O2 -Wall;CFLAGS += -Wall;' \
		-e 's;LFLAGS = -s -pipe;LFLAGS = $(LDFLAGS);' \
		-e 's:gcc -MM:$(CC) -MM:' \
		-e 's:/usr/X11R6:/usr:g' \
		Makefile || die

	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin xnetload
	doman xnetload.1
	dodoc ChangeLog README
	insinto /usr/share/X11/app-defaults/
	doins XNetload
}
