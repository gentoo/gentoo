# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Portable Coroutine Library"
HOMEPAGE="http://www.xmailserver.org/libpcl.html"
SRC_URI="http://www.xmailserver.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="amd64 arm ~arm64 ~loong ppc64 ~riscv x86"

PATCHES=(
	"${FILESDIR}/${P}-musl.patch"
)

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
