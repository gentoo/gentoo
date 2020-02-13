# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Simple disk I/0 latency measuring tool"
HOMEPAGE="https://github.com/koct9i/ioping"
SRC_URI="https://github.com/koct9i/ioping/archive/v1.0.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

src_prepare() {
	default
	sed \
		-e 's:LICENSE::g' \
		-i Makefile || die
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)" \
		PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
