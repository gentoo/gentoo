# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="COmputer Language Manipulation"
HOMEPAGE="https://www.colm.net/open-source/colm/"
SRC_URI="https://www.colm.net/files/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~s390 ~sparc x86 ~x64-macos"

BDEPEND="app-text/asciidoc"

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
