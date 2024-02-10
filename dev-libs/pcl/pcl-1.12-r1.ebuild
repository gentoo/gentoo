# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Portable Coroutine Library"
HOMEPAGE="http://xmailserver.org/libpcl.html"
SRC_URI="http://xmailserver.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/1"
KEYWORDS="amd64 arm arm64 ~loong ppc64 ~riscv x86"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
