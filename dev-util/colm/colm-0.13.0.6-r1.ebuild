# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="COmputer Language Manipulation"
HOMEPAGE="https://www.colm.net/open-source/colm/"
SRC_URI="https://www.colm.net/files/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~x86 ~amd64-linux ~x86-linux"

BDEPEND="app-text/asciidoc"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
