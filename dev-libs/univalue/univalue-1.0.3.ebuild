# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="C++ universal value object and JSON library"
HOMEPAGE="https://github.com/jgarzik/univalue"
SRC_URI="https://codeload.github.com/jgarzik/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

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
