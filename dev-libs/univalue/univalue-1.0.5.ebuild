# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C++ universal value object and JSON library"
HOMEPAGE="https://github.com/jgarzik/univalue"
SRC_URI="https://codeload.github.com/jgarzik/${PN}/tar.gz/v${PV} -> ${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~ppc ~ppc64 x86"
IUSE=""

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
