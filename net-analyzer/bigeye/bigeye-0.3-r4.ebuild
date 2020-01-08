# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="network utility dump and simple honeypot utility"
HOMEPAGE="http://violating.us/projects/bigeye/"
SRC_URI="
	http://violating.us/projects/bigeye/download/${P}.tgz
	https://dev.gentoo.org/~jer/${P}-gcc34.patch.xz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
PATCHES=(
	"${WORKDIR}"/${P}-gcc34.patch
	"${FILESDIR}"/${P}-overflow.patch
)

src_prepare() {
	default
	sed -i README \
		-e "s|-- /messages/|-- /usr/share/bigeye/messages/|g" \
		|| die "sed README"
}

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} src/bigeye.c src/emulate.c -o src/bigeye || die
}

src_install() {
	dobin src/bigeye

	insinto /usr/share/bigeye
	doins sig.file
	doins -r messages

	dodoc README
}
