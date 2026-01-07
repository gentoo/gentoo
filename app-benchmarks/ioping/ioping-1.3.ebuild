# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Simple disk I/0 latency measuring tool"
HOMEPAGE="https://github.com/koct9i/ioping"
SRC_URI="https://github.com/koct9i/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install

	dodoc changelog README.md
}
