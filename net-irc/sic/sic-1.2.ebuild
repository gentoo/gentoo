# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit toolchain-funcs

DESCRIPTION="An extremly simple IRC client"
HOMEPAGE="https://tools.suckless.org/sic"
SRC_URI="https://dl.suckless.org/tools/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

src_prepare() {
	sed -i \
		-e "s/CFLAGS =/CFLAGS +=/g" \
		-e "s/-Os//" \
		-e "s/LDFLAGS = -s/LDFLAGS +=/" \
		-e "/^LIBS =/d" \
		-e "s/= cc/= $(tc-getCC)/g" \
		config.mk || die "sed failed"

	# enable verbose build
	sed -i 's/@${CC}/${CC}/' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
}
